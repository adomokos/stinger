ENV['APP_ENV'] = 'test'

require 'stinger'

require 'pry'
require 'factory_bot'
require 'database_cleaner'

CLIENT_ID = 3

# ActiveRecord::Base.logger = Logger.new(STDOUT)

RSpec.configure do |config|
  config.before(:suite) do
    FactoryBot.find_definitions

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
