# frozen_string_literal: true

class AuthController < ApplicationController
  def auth0_user_exists
    # This checks Auth0 to see if a given user exists as based on their email
    # TODO: We will want to also check if the user exists in our database and
    # and sync between Auth0 and our DB if there is a discrepancy
    access_token = AuthTokenService.fetch_access_token
    domain = Rails.configuration.x.auth0.domain
    url = URI::HTTPS.build(host: domain, path: '/api/v2/users-by-email', query: "email=#{params[:email]}")

    response = user_exists_http_request(url, access_token)
    puts response.code
    puts response.code == "200"
    if response.code == "200"
      user_json = JSON.parse(response.read_body)
      render json: { user_exists: user_json.count.positive? }
    else
      Raven.capture_message("Error checking auth0 user exists endpoint. Url: #{url}. Status: #{response.code}", level: :error)
      # There was an error. Proceed anyhow. If the user already exists, Auth0 will just log the user
      # in rather than signing them up twice; however, once we are storing the user in our app database,
      # we will have to handle this in a different way
      render json: { user_exists: false }
    end
  end

  private

  def user_exists_http_request(url, access_token)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{access_token}"
    request["Accept"] = "application/json"

    http.request(request)
  end
end
