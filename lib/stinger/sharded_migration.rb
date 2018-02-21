module Octopus
  module Migration
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def using_all_shards
        return self unless connection.is_a?(Octopus::Proxy)

        shard_keys = ActiveRecord::Base.connection.shards.keys.map(&:to_sym)
        self.current_shard = shard_keys
        self
      end
    end
  end
end
