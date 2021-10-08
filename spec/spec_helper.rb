require 'pry'

require 'jwt'
require 'openssl'
require 'vcr'
require 'webmock/rspec'

require 'faraday'
require 'faraday_middleware'
require 'faraday/panoptes'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

# autoload everything from the lib directory when testing
Dir.glob(File.join(File.dirname(__FILE__), "..", "lib", "**/*.rb")).each do |f|
  require f
end

def fake_keypair
  @fake_keypair ||= OpenSSL::PKey::RSA.generate 2048
end

def fake_public_key_path
  @fake_public_key_path ||= Tempfile.new('panoptes-client-pubkey').tap do |file|
    file.write(fake_keypair.public_key.to_s)
    file.close
  end
  @fake_public_key_path.path
end

def fake_access_token
  JWT.encode({"data" => {"id" => 1323869}}, fake_keypair, 'RS512')
end

def test_url;           ENV.fetch("ZOONIVERSE_URL",             'https://panoptes-staging.zooniverse.org'); end
def test_talk_url;      ENV.fetch("ZOONIVERSE_TALK_URL",        'https://talk-staging.zooniverse.org'); end
def test_access_token;  ENV.fetch("ZOONIVERSE_ACCESS_TOKEN",    fake_access_token); end
def test_public_key;    ENV.fetch("ZOONIVERSE_PUBLIC_KEY_PATH", fake_public_key_path); end
def test_client_id;     ENV.fetch("ZOONIVERSE_CLIENT_ID",       'x'*64); end
def test_client_secret; ENV.fetch("ZOONIVERSE_CLIENT_SECRET",   'x'*64); end
def panoptes_url; 'https://panoptes-staging.zooniverse.org'.freeze; end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data("<ACCESS_TOKEN>") { test_access_token }
  config.filter_sensitive_data("<CLIENT_ID>")    { test_client_id }
  config.filter_sensitive_data("<CLIENT_SECRET") { test_client_secret }
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.warnings = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  #
  # config.order = :random
  # Kernel.srand config.seed
end

def access_token_connection
  Faraday.new(panoptes_url) do |faraday|
    auth_request faraday, {token: test_access_token}
    configure faraday
  end
end

def credentialed_connection
  Faraday.new(panoptes_url) do |faraday|
    auth_request faraday, {client_id: test_client_id, client_secret: test_client_secret}
    configure faraday
  end
end

def auth_request(faraday, auth)
  if auth[:token]
    faraday.request :panoptes_access_token,
                    url: panoptes_url,
                    access_token: auth[:token]
  elsif auth[:client_id] && auth[:client_secret]
    faraday.request :panoptes_client_credentials,
                    url: panoptes_url,
                    client_id: auth[:client_id],
                    client_secret: auth[:client_secret]
  end
end

def configure(faraday)
  faraday.request :panoptes_api_v1
  faraday.request :json
  faraday.response :json
  faraday.adapter Faraday.default_adapter
end
