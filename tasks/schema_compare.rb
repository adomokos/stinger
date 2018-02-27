#!/usr/bin/env ruby

puts "Schema comprarer is starting up in the ::#{ENV['APP_ENV']}:: environment"

require 'pp'
require_relative '../lib/stinger'

base = :client_3
keys = ActiveRecord::Base.connection.shards.keys
keys.delete(base)

result = keys.each_with_object({}) do |key, sum|
  sum[key] = Stinger::Schemas::Comparer.call(:compare => base, :to => key).report
end

pp result
