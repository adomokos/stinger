module Stinger
  module Schemas
    class PullsTableNamesAction
      extend LightService::Action
      expects :compare
      promises :tables

      executed do |ctx|
        result =
          Stinger::Sharded::Utils
          .connection_for(:shard_name => ctx.compare)
          .execute('SHOW FULL Tables WHERE Table_type="BASE TABLE";')

        ctx.tables = result.inject([]) do |tables, t|
          tables << t.first.to_sym
        end
      end
    end
  end
end
