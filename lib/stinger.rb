$LOAD_PATH.unshift File.dirname(__FILE__)

require 'active_record'
require 'require_all'

require_all 'lib'

db_configuration = YAML.safe_load(IO.read('config/database.yml'), [], [], true)

ActiveRecord::Base.establish_connection(
  db_configuration[ENV['APP_ENV']])
