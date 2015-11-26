require 'faraday'
require 'faraday_middleware'

module Faraday
  module Panoptes
    class ApiV1 < Faraday::Middleware
      def call(env)
        env[:request_headers]["Accept"] = "application/vnd.api+json; version=1"
        env[:request_headers]["Content-Type"] = "application/json"

        @app.call(env)
      end
    end
  end
end
