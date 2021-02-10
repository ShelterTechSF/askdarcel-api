# frozen_string_literal: true

class ServicesController < ApplicationController
  # wrap_parameters is not useful for nested JSON requests because it does not
  # wrap nested resources. It is unclear if the Rails team considers this to be
  # a bug or a feature: https://github.com/rails/rails/issues/17216
  # wrap_parameters is in fact harmful here because the strong params permit
  # method will reject the wrapped parameter if you don't use it.

  wrap_parameters false

  def index
    if params[:category_id]
      all_services = find_by_categories(params[:category_id], params[:eligibility_id])
    elsif params[:eligibility_id]
      all_services = find_by_eligibility(params[:eligibility_id])
    end

    render json: ServicesWithResourcePresenter.present(all_services)
  end

  # rubocop:disable AbcSize
  # rubocop:disable MethodLength
  # rubocop:disable PerceivedComplexity
  def find_by_categories(categories_id_string, eligibilities_id_string)
    query_string = ""
    if categories_id_string.include? ","
      category_ids = categories_id_string.split ","
      first_cat = true
      category_ids.each do |cat_id|
        if first_cat
          query_string = "services.id in (select service_id from categories_services where category_id=" + cat_id + ")"
          first_cat = false
        else
          query_string = query_string +
                         " and services.id in (select service_id from categories_services where category_id=" + cat_id + ")"
        end
      end
    else
      query_string = "services.id in (select service_id from categories_services where category_id=" + cat_id + ")"
    end

    if eligibilities_id_string
      if eligibilities_id_string.include? ","
        eligibility_ids = eligibilities_id_string.split ","
        eligibility_ids.each do |elig_id|
          query_string = query_string +
                         " and services_id in (select service_id from eligibilities_services where eligibility_id=" +
                         elig_id + ")"
        end
      else
        query_string = query_string +
                       " and services_id in (select service_id from eligibilities_services where eligibility_id=" +
                       eligibilities_id_string + ")"
      end
    end
    find_services(query_string)
  end
  # rubocop:enable AbcSize
  # rubocop:enable MethodLength
  # rubocop:enable PerceivedComplexity

  def find_services(query_string)
    services.includes(
      resource: [
        :addresses, :phones, :categories, :notes,
        schedule: :schedule_days,
        services: [:notes, :categories, :addresses, :eligibilities, { schedule: :schedule_days }],
        ratings: [:review]
      ]
    ).where(query_string)
  end

  def find_by_category(category_id_string)
    services.includes(
      resource: [
        :addresses, :phones, :categories, :notes,
        schedule: :schedule_days,
        services: [:notes, :categories, :addresses, :eligibilities, { schedule: :schedule_days }],
        ratings: [:review]
      ]
    ).where(by_category_join_string, (category_id_string.split ","))
  end

  def find_by_eligibility(eligibility_id_string)
    services.includes(
      resource: [
        :addresses, :phones, :categories, :notes,
        schedule: :schedule_days,
        services: [:notes, :categories, :addresses, :eligibilities, { schedule: :schedule_days }],
        ratings: [:review]
      ]
    ).where(by_eligibility_join_string, (eligibility_id_string.split ","))
  end

  def show
    service = services.find(params[:id])
    render json: ServicesWithResourcePresenter.present(service)
  end

  def featured
    category_id = params[:category_id]
    featured_services = services.includes(
      resource: [
        :addresses, :phones, :categories, :notes,
        schedule: :schedule_days,
        services: [:notes, :categories, :addresses, :eligibilities, { schedule: :schedule_days }],
        ratings: [:review]
      ]
    ).where(featured_by_category_join_string, category_id)

    render json: ServicesWithResourcePresenter.present(featured_services)
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
    service.certified_at = Time.now
    service.save!
    render status: :ok
  end

  def pending
    pending_services = services.includes(
      resource: [
        :addresses, :phones, :categories, :notes,
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
      remove_from_algolia(service)
      render status: :ok
    else
      render status: :precondition_failed
    end
  end

  def count
    render json: Service.all.count
  end

  private

  def remove_from_algolia(service)
    service.remove_from_index!
  rescue StandardError
    puts 'failed to remove rservice ' + service.id.to_s + ' from algolia index'
  end

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
      schedule: [{ schedule_days: %i[day opens_at closes_at open_time open_day close_time close_day] }],
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

  def transform_nested_objects(service, resource_id)
    service[:addresses_attributes] = service.delete(:addresses) if service.key? :addresses
    service[:notes_attributes] = service.delete(:notes) if service.key? :notes
    service[:resource_id] = resource_id
  end

  def resource
    @resource ||= Resource.find params[:resource_id] if params[:resource_id]
  end

  def featured_by_category_join_string
    <<~'SQL'
      services.id IN (
        (
          SELECT services.id
            FROM services
            INNER JOIN categories_services ON services.id = categories_services.service_id
            WHERE categories_services.category_id = ?
            AND categories_services.feature_rank > 0
            ORDER BY categories_services.feature_rank
        )
      )
    SQL
  end

  def by_category_join_string
    <<~'SQL'
      services.id IN (
        (
          SELECT services.id
            FROM services
            INNER JOIN categories_services ON services.id = categories_services.service_id
            WHERE categories_services.category_id in (?)
        )
      )
    SQL
  end

  def by_eligibility_join_string
    <<~'SQL'
      services.id IN (
        (
          SELECT services.id
            FROM services
            INNER JOIN eligibilities_services ON services.id = eligibilities_services.service_id
            WHERE eligibilities_services.eligibility_id in (?)
        )
      )
    SQL
  end
end
