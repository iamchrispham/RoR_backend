if ENV.fetch('COVERAGE', false)
  require 'simplecov'
  SimpleCov.start 'rails'
end

require 'webmock/rspec'

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = 'tmp/rspec_examples.txt'
  config.order = :random
end

WebMock.disable_net_connect!(allow_localhost: true)

def parse_api_response
  api_response = JSON.parse(response.body)

  code = api_response['code']
  message = api_response['message']
  data = api_response['data']

  [code, message, data]
end

def setup_json_request
  request.env['CONTENT_TYPE'] = 'application/json'
end

def mock_facebook_me
  facebook_profile = {
    id: 12_345,
    email: 'test@test.com'
  }.to_json
  stub_request(:get, /.*facebook.com\/me.*/)
    .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => /.*/, 'User-Agent' => /.*/ })
    .to_return(status: 200, body: facebook_profile, headers: {})
end
