class ServicesController < ApplicationController
  before_action :require_admin_signed_in!, except: [:create]

  # wrap_parameters is not useful for nested JSON requests because it does not
  # wrap nested resources. It is unclear if the Rails team considers this to be
  # a bug or a feature: https://github.com/rails/rails/issues/17216
  # wrap_parameters is in fact harmful here because the strong params permit
  # method will reject the wrapped parameter if you don't use it.
  wrap_parameters false

  def create
    services_params = clean_services_params
    services = services_params.map { |s| Service.new(s) }
    if services.any?(&:invalid?)
      render status: :bad_request, json: { services: services.select(&:invalid?).map(&:errors) }
    else
      Service.transaction { services.each(&:save!) }
      render status: :created, json: { services: services.map { |s| ServicesPresenter.present(s) } }
    end
  end

  def pending
    pending_services = services.includes(resource: [
      :address, :phones, :categories, :notes, schedule: :schedule_days,
      services: [:notes, :categories, { schedule: :schedule_days }],
      ratings: [:review]]).pending
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

  private

  def services
    Service.includes(:notes, :categories, schedule: :schedule_days)
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
      :name,
      :long_description,
      :eligibility,
      :required_documents,
      :fee,
      :application_process,
      :email,
      schedule: [{ schedule_days: [:day, :opens_at, :closes_at] }],
      notes: [:note],
      categories: [:id]
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
    service[:notes_attributes] = service.delete(:notes) if service.key? :notes
    service[:resource_id] = resource_id
    # Unlike other nested resources, don't create new categories; associate
    # with the existing ones.
    service['category_ids'] = service.delete(:categories).collect { |h| h[:id] } if service.key? :categories
  end

  def resource
    @resource ||= Resource.find params[:resource_id] if params[:resource_id]
  end
end
