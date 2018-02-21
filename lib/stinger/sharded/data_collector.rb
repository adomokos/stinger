module Stinger
  module Sharded
    class DataCollector
      extend LightService::Organizer

      def self.call(criterias)
        ctx = LightService::Context.make(:criterias => criterias,
                                         :result => {})

        Stinger::Sharded::Utils.using_all_with_conn do |conn|
          ctx[:conn] = conn
          with(ctx).reduce(
            [RunsCriteriasAction]
          )
        end

        ctx.result
      end
    end

    class RunsCriteriasAction
      extend LightService::Action
      expects :criterias, :result, :conn

      executed do |ctx|
        ctx.criterias.each do |topic, criteria|
          shard_name = ctx.conn.current_shard.to_sym
          ctx.result[shard_name] ||= {}

          if criteria.arity.zero?
            ctx.result[shard_name].merge!(topic => criteria.call)
          else
            ctx.result[shard_name].merge!(topic => criteria.call(ctx))
          end
        end
      end
    end
  end
end
