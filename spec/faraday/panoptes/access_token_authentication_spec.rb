describe Faraday::Panoptes::AccessTokenAuthentication, :vcr do
  it('should instantiate a connection') do
    connection = access_token_connection
    expect(connection).not_to be(nil)
  end

  it('should make a get request') do
    connection = access_token_connection
    response = connection.send :get, "/api/me"
    expect(response).not_to be(nil)
  end
end
