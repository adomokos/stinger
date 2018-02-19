puts "Console is starting up in the ::#{ENV['APP_ENV']}:: environment"
require 'pry'

require 'active_record'

ARGV.clear
ActiveRecord::Base.logger = Logger.new(STDOUT)
Pry.start
