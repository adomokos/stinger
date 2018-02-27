#!/usr/bin/env ruby

puts "Asset count is starting up in the ::#{ENV['APP_ENV']}:: environment"

require_relative '../lib/stinger'

counter = 1
Thread.current[:client_id] = 2
Stinger::Asset.where(:client_id => 2).take(20).each do |a|
  puts counter
  sa = Stinger::Sharded::Asset.new(a.attributes)
  sa.save!
  Stinger::Sharded::Vulnerability.bulk_insert do |worker|
    a.vulnerabilities.each do |v|
      worker.add(
        :id => v.id,
        :client_id => v.client_id,
        :asset_id => v.asset_id,
        :cve_id => v.cve_id,
        :notes => v.notes,
        :created_at => v.created_at,
        :updated_at => v.updated_at
      )
    end
  end
  counter += 1
end

puts Stinger::Asset.count
puts Stinger::Sharded::Asset.count
