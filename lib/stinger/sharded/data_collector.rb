module Stinger
  module Sharded
    class DataCollector
      def self.run(criterias)
        result = {}

        Stinger::Sharded::Utils.using_all_with_conn do |conn|
          criterias.each do |topic, criteria|
            shard_name = conn.current_shard.to_sym
            result[shard_name] ||= {}

            result[shard_name].merge!(topic => criteria.call)
          end
        end

        result
      end
    end
  end
end
