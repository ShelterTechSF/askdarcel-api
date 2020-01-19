# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end

  before_action :cachable
  before_action :set_raven_context

  def cachable
    expires_in 1.second, public: true, must_revalidate: false
  end

  # Update AirTable with a org's 'name', 'status' & 'updated_at'
  def update_in_airtable(org)
    create_org_in_airtable(org) unless update_org_in_airtable(org)
  rescue StandardError => e
    puts 'failed to update org ' + org.id.to_s + ' to airtable: ' + e.to_s
  end

  private

  def require_authorization!
    head :unauthorized unless current_user
  end

  def current_user
    return @current_user if defined? @current_user

    user_id = request.headers['Authorization']
    @current_user = User.where(id: user_id).first
  end

  def set_raven_context
    Raven.user_context(id: current_user.id) if current_user
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def create_org_in_airtable(org)
    AirTableOrgs.create("ID" => org.id,
                        "Organization Name" => org.name,
                        "DB Status" => org.status,
                        "Last Modified (DB)" => org.updated_at,
                        "Created At (DB)" => org.created_at)
  end

  def update_org_in_airtable(org)
    airtable_org = AirTableOrgs.all(filter: "{ID} = " + org.id.to_s)
    return unless airtable_org[0]

    airtable_org[0]["Organization Name"] = org.name
    airtable_org[0]["DB Status"] = org.status
    airtable_org[0]["Last Modified (DB)"] = org.updated_at
    airtable_org[0].save
  end
end
