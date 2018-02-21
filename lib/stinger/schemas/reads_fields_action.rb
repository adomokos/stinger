module Stinger
  module Schemas
    class ReadsFieldsAction
      extend LightService::Action
      expects :compare, :to, :report, :table
      promises :compare_columns, :to_columns

      executed do |ctx|
        ctx.report[ctx.table] = []
        ctx.compare_columns = read_columns_for(ctx.compare, ctx.table)

        ctx.to_columns = read_columns_for(ctx.to, ctx.table)
      end

      def self.read_columns_for(shard_name, table)
        result = Stinger::Sharded::Utils
                 .connection_for(:shard_name => shard_name)
                 .execute("describe #{table};")
        result.inject([]) do |acc, x|
          acc << {
            :field => x[0],
            :type => x[1],
            :null => x[2],
            :key => x[3],
            :default => x[4],
            :extra => x[5]
          }
        end
      end
    end
  end
end
