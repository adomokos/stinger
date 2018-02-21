module Stinger
  module Sharded
    module Utils
      module_function

      def shard_name_for(client_id)
        current_shard = ActiveRecord::Base.connection.current_shard.to_sym
        return current_shard unless client_id

        key_to_lookup = "client_#{client_id}".to_sym
        known_shards = ActiveRecord::Base.connection.shard_names.map(&:to_sym)

        known_shards.detect { |shard| shard == key_to_lookup } || :master
      end
    end
  end
end
