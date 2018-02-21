require_relative 'lib/stinger'

require 'active_record'
require 'yaml'
require 'mysql2'
require 'logger'

# Ideas from here: http://exposinggotchas.blogspot.com/2011/02/activerecord-migrations-without-rails.html

# rubocop:disable all
namespace :db do
  namespace :sharded do
    desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
    task :migrate => :environment do
      ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
    end

    desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
    task :rollback => :environment do
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      ActiveRecord::Migrator.rollback 'db/migrate', step
    end

    task :environment do
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end
  end
end
# rubocop:enable all
