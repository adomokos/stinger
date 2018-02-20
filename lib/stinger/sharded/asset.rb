module Stinger
  module Sharded
    class Asset < Sharded::Base
      has_many :vulnerabilities
    end
  end
end
