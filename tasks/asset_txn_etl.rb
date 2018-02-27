#!/usr/bin/env ruby

puts "Asset Transactional ETL is starting up in the ::#{ENV['APP_ENV']}:: environment"

require_relative '../lib/stinger'

counter = 1
Stinger::Asset.where(:client_id => 2).take(20).each do |a|
  puts counter
  sa = Stinger::Sharded::Asset.using(:client_2).new(a.attributes)
  sa.save!
  a.vulnerabilities.each do |v|
    sv = Stinger::Sharded::Vulnerability.using(:client_2).new(v.attributes)
    sv.save!
  end
  counter += 1
end

puts Stinger::Asset.count
puts Stinger::Sharded::Asset.using(:client_2).count
