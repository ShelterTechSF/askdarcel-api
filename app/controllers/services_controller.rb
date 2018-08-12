# frozen_string_literal: true

class ServicesController < ApplicationController
  before_action :require_admin_signed_in!, except: %i[show create destroy certify count]

  # wrap_parameters is not useful for nested JSON requests because it does not
  # wrap nested resources. It is unclear if the Rails team considers this to be
  # a bug or a feature: https://github.com/rails/rails/issues/17216
  # wrap_parameters is in fact harmful here because the strong params permit
  # method will reject the wrapped parameter if you don't use it.

  wrap_parameters false

  def show
    service = services.find(params[:id])
    render json: ServicesWithResourcePresenter.present(service)
  end

  def create
    services_params = clean_services_params
    services = services_params.map { |s| Service.new(s) }
    services.each { |s| s.status = :approved }
    if services.any?(&:invalid?)
      render status: :bad_request, json: { services: services.select(&:invalid?).map(&:errors) }
    else
      Service.transaction { services.each(&:save!) }
      render status: :created, json: { services: services.map { |s| ServicesPresenter.present(s) } }
    end
  end

  def certify
    service = Service.find params[:service_id]
    service.certified = true
    service.save!
    render status: :ok
  end

  def pending
    pending_services = services.includes(
      resource: [
        :address, :phones, :categories, :notes,
        schedule: :schedule_days,
        services: [:notes, :categories, :addresses, :eligibilities, { schedule: :schedule_days }],
        ratings: [:review]
      ]
    ).pending
    render json: ServicesWithResourcePresenter.present(pending_services)
  end

  def approve
    service = Service.find params[:service_id]
    if service.pending?
      service.approved!
      render status: :ok
    elsif service.approved?
      render status: :not_modified
    else
      render status: :precondition_failed
    end
  end

  def reject
    service = Service.find params[:service_id]
    if service.pending?
      service.rejected!
      render status: :ok
    elsif service.rejected?
      render status: :not_modified
    else
      render status: :precondition_failed
    end
  end

  def destroy
    service = Service.find params[:id]
    if service.approved?
      service.inactive!
      render status: :ok
    else
      render status: :precondition_failed
    end
  end

  def count
    render json: Service.all.count
  end

  private

  def services
    Service.includes(:notes, :categories, :eligibilities, :addresses, schedule: :schedule_days)
  end

  # Clean raw request params for interoperability with Rails APIs.
  def clean_services_params
    services_params = params.require(:services).map { |s| permit_service_params(s) }
    resource_id = params.require(:resource_id)
    services_params.each { |s| transform_service_params!(s, resource_id) }
  end

  # Filter out all the attributes that are unsafe for users to set, including
  # all :id keys besides category ids and Service's :status.
  def permit_service_params(service_params) # rubocop:disable Metrics/MethodLength
    service_params.permit(
      :alternate_name,
      :application_process,
      :eligibility,
      :email,
      :fee,
      :interpretation_services,
      :long_description,
      :name,
      :required_documents,
      :url,
      :wait_time,
      schedule: [{ schedule_days: %i[day opens_at closes_at] }],
      notes: [:note],
      categories: [:id],
      addresses: %i[id address_1 city state_province postal_code country],
      eligibilities: [:id]
    )
  end

  # Transform parameters for creating a single service in-place.
  #
  # Rails doesn't accept the same format for nested parameters when creating
  # models as the format we output when serializing to JSON. In particular, the
  # Model#new method expects the key for nested resources to have a suffix of
  # "_attributes"; e.g. "notes_attributes", not "notes".
  #
  # This method transforms all keys representing nested resources into
  # #{key}_attribute.
  def transform_service_params!(service, resource_id)
    if service.key? :schedule
      schedule = service[:schedule_attributes] = service.delete(:schedule)
      schedule[:schedule_days_attributes] = schedule.delete(:schedule_days) if schedule.key? :schedule_days
    end

    transform_nested_objects(service, resource_id)
    # Unlike other nested resources, don't create new categories; associate
    # with the existing ones.
    service['category_ids'] = service.delete(:categories).collect { |h| h[:id] } if service.key? :categories
    service['eligibility_ids'] = service.delete(:eligibilities).collect { |h| h[:id] } if service.key? :eligibilities
  end
  # rubocop:enable Metrics/AbcSize

  def transform_nested_objects(service, resource_id)
    service[:addresses_attributes] = service.delete(:addresses) if service.key? :addresses
    service[:notes_attributes] = service.delete(:notes) if service.key? :notes
    service[:resource_id] = resource_id
  end

  def resource
    @resource ||= Resource.find params[:resource_id] if params[:resource_id]
  end
end
