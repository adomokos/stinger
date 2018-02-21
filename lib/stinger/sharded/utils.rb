module Stinger
  module Sharded
    module Utils
      module_function

      RESERVED_BITS_FOR_ENTITY_ID = 40

      def shard_name_for(client_id)
        current_shard = ActiveRecord::Base.connection.current_shard.to_sym
        return current_shard unless client_id

        key_to_lookup = "client_#{client_id}".to_sym
        known_shards = ActiveRecord::Base.connection.shard_names.map(&:to_sym)

        known_shards.detect { |shard| shard == key_to_lookup } || :master
      end

      def client_id_from(shard_key)
        shard_key.to_s.gsub('client_', '').to_i
      end

      def ids_from_shard_id(shard_id)
        client_id = (shard_id >> RESERVED_BITS_FOR_ENTITY_ID) & 0x3FFFFF # max 22 bits
        entity_id = (shard_id >> 0) & 0xFFFFFFFFFF # max 40 bits
        [client_id, entity_id]
      end

      def calculate_shard_id_from(client_id, entity_id)
        (client_id << RESERVED_BITS_FOR_ENTITY_ID) | (entity_id << 0)
      end

      # Returns a connection to the specified shard
      def connection_for(shard_name: nil, client_id: nil)
        used_shard = if client_id
                       shard_name_for(client_id)
                     else
                       shard_name
                     end

        Octopus.using(used_shard) do
          ActiveRecord::Base.connection.select_connection
        end
      end

      # Octopus#using_all { } will iterate over all
      # shards and call the block passed to it. Our
      # tweak on it will set the `client_id` in the
      # current Thread for each iteration
      def using_all_with_conn
        old_client_id = Thread.current[:client_id]

        result = Octopus.using_all do
          conn = ActiveRecord::Base.connection
          shard_name = conn.current_shard.to_sym

          client_id = client_id_from(shard_name)
          Thread.current[:client_id] = client_id

          yield(conn)
        end

        Thread.current[:client_id] = old_client_id

        result
      end
    end
  end
end
