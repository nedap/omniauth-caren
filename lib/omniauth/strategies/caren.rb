require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Caren < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'basic'

      option :name, 'caren'

      option :client_options, {
        :site => "http://caren-provider.dev:3005",
        :authorize_url => "/oauth/authorize"
      }

      option :authorize_options, [:scope, :display, :auth_type]

      uid { raw_info["id"] }

      info do
        {
          :email => raw_info["email"]
        }
      end

      # Add the raw info to the data object
      extra do
        skip_info? ? {} : { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/credentials.json').parsed
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
    end
  end
end
