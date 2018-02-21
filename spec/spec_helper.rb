ENV['APP_ENV'] = 'test'

require 'stinger'

require 'pry'
require 'factory_bot'
require 'database_cleaner'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/shared_examples/*.rb'].each { |f| require f }

CLIENT_ID = 2
SHARDED_CLIENT_ID = 3

# ActiveRecord::Base.logger = Logger.new(STDOUT)

class BlankModel < ActiveRecord::Base; end

RSpec.configure do |config|
  config.before(:suite) do
    FactoryBot.find_definitions

    # There might be a better way of configuring Octopus with AR
    # but this was the simplest and the least invasive.
    # DatabaseCleaner now clears both the master and the vuln_data_3_test DB as well.
    BlankModel.using(:master).connection.shards.each_value do |conn|
      DatabaseCleaner[:active_record, :connection => conn].strategy = :transaction
      DatabaseCleaner[:active_record, :connection => conn].clean_with(:truncation)
    end
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
