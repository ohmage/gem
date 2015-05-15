require 'spec_helper'

describe Ohmage::Client do
  before do
    stub_get('config/read').with(query: {client: 'ruby-ohmage'}).to_return(status: 200, body: fixture('config_read.json'), headers: {'Content-Type' => 'application/json'})
    @client = Ohmage::Client.new(user: 'testuser', password: 'testpass', server_url: 'https://test.mobilizingcs.org/')
  end

  describe '#server_config' do
    it 'returns server info' do
      expect(@client.server_config[:mobility_enabled]).to be false
    end
  end

  describe '#token' do
    it 'does not exist before any request is made' do
      expect(@client.token).to be nil
    end
    it 'exists after successful request is made' do
      stub_post('user/auth_token').with(query: {client: 'ruby-ohmage', user: 'testuser', password: 'testpass'}).to_return(status: 200, body: fixture('user_auth_token_success.json'), headers: {'Content-Type' => 'application/json'})
      @client.auth_token
      expect(@client.token).to eq('37d350a8-4585-406d-89e3-c5632626ce04')
    end
    it 'raises unauthorized error if credentials were incorrect' do
      client = Ohmage::Client.new(user: 'testuser', password: 'badpass', server_url: 'https://test.mobilizingcs.org/')
      stub_post('user/auth_token').with(query: {client: 'ruby-ohmage', user: 'testuser', password: 'badpass'}).to_return(status: 200, body: fixture('user_auth_token_failure.json'), headers: {'Content-Type' => 'application/json'})
      expect { client.auth_token }.to raise_error(Ohmage::Error::Unauthorized, 'Unknown user or incorrect password.')
    end
  end
end
