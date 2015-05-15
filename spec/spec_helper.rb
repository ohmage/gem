require 'webmock/rspec'
require 'ohmage'
WebMock.disable_net_connect!(allow_localhost: true)

def stub_get(path)
  stub_request(:get, 'https://test.mobilizingcs.org/app/' + path)
end

def stub_post(path)
  stub_request(:post, 'https://test.mobilizingcs.org/app/' + path)
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end
