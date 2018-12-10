require 'webmock/rspec'

require 'rails/all'
require 'rspec/rails'
require 'database_cleaner'
require 'shoulda-matchers'
require 'factory_girl_rails'
require 'stripe_mock'
require 'activerecord-tableless'
require 'showoff_serializable'

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.color = true
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  config.include Showoff::Helpers::SerializationHelper

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

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

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

WebMock.disable_net_connect!(allow_localhost: true)

Dir[File.expand_path('..', __FILE__) + '/support/**/*.rb'].sort.each { |file| require file }