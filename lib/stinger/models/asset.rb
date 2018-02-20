module Stinger
  class Asset < ActiveRecord::Base
    belongs_to :client
    has_many :vulnerabilities
  end
end
