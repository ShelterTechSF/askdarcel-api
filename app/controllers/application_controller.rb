# frozen_string_literal: true

require "jwt"
require "auth0_client"

class ApplicationController < ActionController::API
  include Secured

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
    puts "failed to update org #{org.id} to airtable: #{e}"
  end

  private

  # This checks if a JWT provided with the request is valid
  # rubocop:disable Metrics/AbcSize
  def require_authorization!
    if !request.cookies["CF_Authorization"] || request.cookies["CF_Authorization"].nil?
      logger.info "Request rejected because of no safe CF_Authorization cookie in request header"
      head :unauthorized
      return
    end
    # This is the public key from the cert that the JWT is issued by
    public_key = Rails.configuration.x.authorization.cert.public_key
    decoded_token = JWT.decode request.cookies["CF_Authorization"], public_key, true, algorithm: "RS256"
    logger.info "Admin API call by: #{decoded_token[0]['email']}"
  end
  # rubocop:enable Metrics/AbcSize

  def set_raven_context
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
    airtable_org = AirTableOrgs.all(filter: "{ID} = #{org.id}")
    return unless airtable_org[0]

    airtable_org[0]["Organization Name"] = org.name
    airtable_org[0]["DB Status"] = org.status
    airtable_org[0]["Last Modified (DB)"] = org.updated_at
    airtable_org[0].save
  end
end
