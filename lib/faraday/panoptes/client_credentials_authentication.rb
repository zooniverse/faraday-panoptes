require 'faraday'
require 'faraday_middleware'

module Faraday
  module Panoptes

    class CredentialsOAuthError < StandardError
    end

    class ClientCredentialsAuthentication < Faraday::Middleware
      dependency do
        require 'json' unless defined?(::JSON)
      end

      def initialize(app, url:, client_id:, client_secret:)
        super(app)
        @client_id = client_id
        @client_secret = client_secret
        @conn = Faraday.new(url: url)
        @current_token = nil
      end

      def call(env)
        env[:request_headers]["Authorization"] = authorization_header
        @app.call(env)
      end

      def authorization_header
        "Bearer #{access_token}"
      end

      def access_token
        if need_new_token?
          @current_token = get_token
        end

        @current_token["access_token"]
      end

      def need_new_token?
        return true unless @current_token

        created_at = Time.at(@current_token.fetch("created_at"))
        expires_by = created_at + @current_token.fetch("expires_in")
        Time.now > expires_by
      end

      def get_token
        result = @conn.post("/oauth/token",
          grant_type: 'client_credentials',
          client_id: @client_id,
          client_secret: @client_secret)

        raise CredentialsOAuthError.new "Failed to obtain access token" if result.status == 422 or result.body.empty?
        JSON.parse(result.body)
      end
    end
  end
end
