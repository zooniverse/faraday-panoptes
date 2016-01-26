require "faraday/panoptes/version"
require 'faraday/panoptes/api_v1'
require 'faraday/panoptes/access_token_authentication'
require 'faraday/panoptes/client_credentials_authentication'

module Faraday
  module Panoptes
    Faraday::Request.register_middleware \
      panoptes_access_token: lambda { AccessTokenAuthentication },
      panoptes_client_credentials: lambda { ClientCredentialsAuthentication },
      panoptes_api_v1: lambda { ApiV1 }
  end
end

