require 'googleauth'
require 'googleauth/stores/file_token_store'

class GoogleSearchConsoleController < ApplicationController
  CLIENT_SECRETS_PATH = 'client_secrets.json'.freeze
  SCOPES = [
    'https://www.googleapis.com/auth/webmasters.readonly'
  ].freeze

  def authorize
    authorizer = Google::Auth::WebUserAuthorizer.new(
      client_id,
      SCOPES,
      token_store: token_store,
      redirect_uri: redirect_uri
    )
    params = {
      client_id: client_id.id,
      response_type: 'code',
      scope: SCOPES.join(' '),
      redirect_uri: redirect_uri,
      state: ''
    }
    auth_uri = URI::HTTPS.build(
      host: 'accounts.google.com',
      path: '/o/oauth2/auth',
      query: URI.encode_www_form(params)
    ).to_s

    pp "redirectUri"
    pp redirect_uri
    redirect_to auth_uri, allow_other_host: true
  end

  def callback
    authorizer = Google::Auth::WebUserAuthorizer.new(
      client_id,
      SCOPES,
      token_store: token_store
    )

    # user_id = current_user.id.to_s # Use your authentication system's current user ID
    # credentials = authorizer.get_credentials(user_id)
    user_id = "baskint"
    credentials = nil

    pp "cbu:"
    pp callback_url(request)

    if credentials.nil?
      code = request.query_parameters['code'] # Access the authorization code from the request

      # Exchange the authorization code for credentials and store them
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id,
        code: code,
        base_url: callback_url(request)
      )
    end

    redirect_to root_path
  end

  private

  def client_id
    Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  end

  def token_path
    Rails.root.join('.credentials', "google_search_console_api_rails.yaml")
  end

  def redirect_uri
    'http://localhost:3000/google_search_console/callback' # Replace with your redirect URI
  end

  def token_store
    FileUtils.mkdir_p(token_directory) unless File.directory?(token_directory)
    Google::Auth::Stores::FileTokenStore.new(file: token_path)
  end

  def token_directory
    Rails.root.join('.credentials').to_s
  end

  def callback_url(request)
    url_for(action: 'callback', controller: 'google_search_console', only_path: false, protocol: request.protocol, host: request.host_with_port)
  end
end
