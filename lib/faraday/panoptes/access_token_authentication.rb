require 'faraday'
require 'faraday_middleware'

module Faraday
  module Panoptes
    class AccessTokenAuthentication < Faraday::Middleware
      dependency do
        require 'json' unless defined?(::JSON)
      end

      def initialize(app, url:, access_token:)
        super(app)
        @access_token = access_token
      end

      def call(env)
        env[:request_headers]["Authorization"] = authorization_header
        @app.call(env)
      end

      def authorization_header
        "Bearer #{access_token}"
      end

      def access_token
        @access_token
      end
    end
  end
end
