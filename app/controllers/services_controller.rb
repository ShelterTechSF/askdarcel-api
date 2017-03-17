class ServicesController < ApplicationController
  before_action :require_admin_signed_in!, except: [:create]

  # wrap_parameters is not useful for nested JSON requests because it does not
  # wrap nested resources. It is unclear if the Rails team considers this to be
  # a bug or a feature: https://github.com/rails/rails/issues/17216
  # wrap_parameters is in fact harmful here because the strong params permit
  # method will reject the wrapped parameter if you don't use it.
  wrap_parameters false

  def create
    service_params = clean_service_params_for_create
    # Set categories separately because unlike the other nested resources,
    # categories are many-to-many with services and we should associate the
    # service with the existing categories.
    category_ids = service_params.delete(:categories).collect { |h| h[:id] }
    @service = Service.create(service_params)
    if @service.valid?
      @service.category_ids = category_ids
      render status: :created, json: ServicesPresenter.present(@service)
    else
      render status: :bad_request, json: @service.errors
    end
  rescue
    render status: :bad_request
  end

  def pending
    render json: ServicesPresenter.present(services.pending)
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
    Service.includes(:notes, schedule: :schedule_days)
  end

  # Clean params for creating service
  #
  # Rails doesn't accept the same format for nested parameters when creating
  # models as the format we output when serializing to JSON. In particular, the
  # Model#create method expects the key for nested resources to have a suffix of
  # "_attributes"; e.g. "notes_attributes", not "notes". See
  # http://stackoverflow.com/a/8719885
  #
  # This method transforms all keys representing nested resources into
  # #{key}_attribute.
  #
  # In addition, it filters out all the attributes that are unsafe for users to
  # set, including all :id keys besides category ids and Service's :status.
  def clean_service_params_for_create
    service_params = params.permit(
      :name,
      :long_description,
      :eligibility,
      :required_documents,
      :fee,
      :application_process,
      :resource_id,
      :email,
      schedule: [
        {schedule_days: [:day, :opens_at, :closes_at]},
      ],
      notes: [:note],
      categories: [:id],
    )

    if service_params.key? :schedule
      schedule = service_params[:schedule_attributes] = service_params.delete(:schedule)
      schedule[:schedule_days_attributes] = schedule.delete(:schedule_days)
    end
    service_params[:notes_attributes] = service_params.delete(:notes) if service_params.key? :notes
    service_params
  end

  def resource
    @resource ||= Resource.find params[:resource_id] if params[:resource_id]
  end
end
