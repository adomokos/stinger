$LOAD_PATH.unshift File.dirname(__FILE__)

module Stinger
  class Configuration
    @app_env = ENV['APP_ENV']

    class << self
      attr_reader :app_env
    end
  end
end

require 'active_record'
require 'octopus'
require 'require_all'
require 'pry'

require_all 'lib'

db_configuration = YAML.safe_load(IO.read('config/database.yml'), [], [], true)

ActiveRecord::Base.establish_connection(
  db_configuration[Stinger::Configuration.app_env])

# Ugly monkey-patch as Octopus is primarily used in Rails
module Octopus
  def self.rails_env
    @rails_env ||= Stinger::Configuration.app_env
  end
end
