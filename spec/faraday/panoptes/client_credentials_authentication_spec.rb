describe Faraday::Panoptes::ClientCredentialsAuthentication, :vcr do
  let(:connection) { credentialed_connection }

  it('should instantiate a connection') do
    expect(connection).not_to be(nil)
  end

  it('should return a sensible error if authentication fails') do
    expect{connection.send(:get, 'api/me')}.to raise_error(Faraday::Panoptes::CredentialsOAuthError)
  end

  #TODO: get some credentials set up on staging to use
  xit('should make a get request') do
    response = connection.send(:get, 'api/me')
    expect(response).not_to be(nil)
  end
end
