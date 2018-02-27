module Stinger
  module Sharded
    class DataCollector
      def self.run(criterias)
        criterias.each_with_object({}) do |(topic, criteria), result|
          Stinger::Sharded::Utils.using_all_with_conn do |conn|
            shard_name = conn.current_shard.to_sym
            result[shard_name] ||= {}

            result[shard_name].merge!(topic => criteria.call)
          end
        end
      end
    end
  end
end
