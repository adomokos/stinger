#!/usr/bin/env ruby

puts "Asset count is starting up in the ::#{ENV['APP_ENV']}:: environment"

require_relative '../lib/stinger'

puts Stinger::Sharded::DataCollector.run([[:asset_count, -> { Stinger::Sharded::Asset.count }]])
