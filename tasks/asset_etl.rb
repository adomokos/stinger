#!/usr/bin/env ruby

puts "Asset count is starting up in the ::#{ENV['APP_ENV']}:: environment"

require_relative '../lib/stinger'

Stinger::Asset.take(100).each do |a|
  sa = Stinger::Sharded::Asset.using(:client_2).new(a.attributes)
  sa.save!
  a.vulnerabilities.each do |v|
    sv = Stinger::Sharded::Vulnerability.using(:client_2).new(v.attributes)
    sv.save!
  end
end

puts Stinger::Asset.count
