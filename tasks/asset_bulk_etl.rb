#!/usr/bin/env ruby

puts "Asset bulk ETL is starting up in the ::#{ENV['APP_ENV']}:: environment"

require_relative '../lib/stinger'

# ActiveRecord::Base.logger = Logger.new(STDOUT)

counter = 1
Thread.current[:client_id] = 2
Stinger::Asset.where(:client_id => 2).take(20).each do |a|
  puts counter
  sa = Stinger::Sharded::Asset.new(a.attributes)
  sa.save!
  Stinger::Sharded::Vulnerability.bulk_insert do |worker|
    a.vulnerabilities.each do |v|
      worker.add(v.attributes)
    end
  end
  counter += 1
end

puts Stinger::Asset.count
puts Stinger::Sharded::Asset.count
