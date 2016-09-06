require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Caren < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'basic'

      option :name, 'caren'

      option :client_options, {
        :site => "https://www.carenzorgt.nl",
        :authorize_url => "/login/oauth/authorize"
      }

      option :authorize_options, [:scope, :display, :auth_type]

      # Define the uid of the resource
      uid { person["id"] }

      # Defines the information we want to expose to the omniauth client
      # @return [Hash] the user information of Caren
      info do
        {
          :first_name     => person["first_name"],
          :last_name      => person["last_name"],
          :email          => person["email"],
          :mobile_phone   => person["mobile_phone"],
          :date_of_birth  => person["date_of_birth"],
          :photo          => person["photo"],
          :locale         => person["locale"]
        }
      end

      # Add the raw info to the data object
      extra do
        skip_info? ? {} : { :raw_info => person }
      end

      # Retrieves the user information from the Caren Api
      # @return [Hash] the parsed json response for the user object
      def raw_info
        @raw_info ||= access_token.get('/api/v1/user.json').parsed
      end

      # Retrieves the embedded person object from the `raw_info`
      # @return [Hash] the personal information of the caren account
      def person
        raw_info["_embedded"]["person"]
      end

      # You can pass +display+, +scope+, or +auth_type+ params to the auth
      # request, if you need to set them dynamically. You can also set these
      # options in the OmniAuth config :authorize_params option.
      #
      # For example: /auth/caren?display=popup or /auth/caren?scope=basic
      def authorize_params
        super.tap do |params|
          %w[display scope auth_type].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end

          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      # Defines the callback_url "downstream" in stead of more upstream in
      # the omniauth-oauth2 gem. The newest version of omniauth-oauth2 broke
      # the previous behavior. More on this, see: https://github.com/intridea/omniauth-oauth2/issues/81
      # @return [String] the callback_url
      def callback_url
        full_host + script_name + callback_path
      end

    end
  end
end
