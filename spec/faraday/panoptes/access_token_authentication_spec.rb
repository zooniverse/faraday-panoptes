describe Faraday::Panoptes::AccessTokenAuthentication, :vcr do
  it('should be sane') do
    expect(true).to be(true)
  end

  it('should instantiate a connection') do
    connection = access_token_connection
    expect(connection).not_to be(nil)
  end

  it('should fetch something') do
    connection = access_token_connection
    response = connection.send :get, "/api/me"
    expect(response).not_to be(nil)
  end
end
