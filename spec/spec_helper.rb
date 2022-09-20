# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
ENV["RAILS_ENV"] ||= 'test'
require 'factory_bot'
require 'webmock/rspec'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

RSpec.configure do |config|
  config.fixture_path = Rails.root.join('spec', 'fixtures')
  config.global_fixtures = :all

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.include FactoryBot::Syntax::Methods

  # Database cleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end
  config.around(:each, :without_transactions => true) do |ex|
    DatabaseCleaner.strategy = [:deletion, except: %w[confs promotions]]
    ex.run
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:each) { ActiveSupport::CurrentAttributes.reset_all }
end
