module Stinger
  class Client < ActiveRecord::Base
    has_many :assets
    has_many :vulnerabilities
  end
end
