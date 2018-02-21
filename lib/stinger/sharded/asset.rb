module Stinger
  module Sharded
    class Asset < Sharded::Base
      has_many :vulnerabilities

      # belongs_to :client won't work,
      # as the Client record is in a
      # different DB
      def client
        Stinger::Client.find(client_id)
      end
    end
  end
end
