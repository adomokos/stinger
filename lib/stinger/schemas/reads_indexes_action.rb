module Stinger
  module Schemas
    class ReadsIndexesAction
      extend LightService::Action
      expects :compare, :to, :table
      promises :compare_indexes, :to_indexes

      executed do |ctx|
        compare_database = database_for(ctx.compare)
        to_database = database_for(ctx.to)

        ctx.compare_indexes = read_indexes_for(ctx.table, compare_database, ctx.compare)

        ctx.to_indexes = read_indexes_for(ctx.table, to_database, ctx.to)
      end

      def self.read_indexes_for(table, database, shard_name)
        indexes_rs = collect_indexes_for(table, database, shard_name)

        indexes = indexes_rs.map do |idx|
          {
            :table_name => idx[0],
            :index_name => idx[1],
            :non_unique => idx[2],
            :seq_in_index => idx[3],
            :column_name => idx[4],
            :index_type => idx[5]
          }
        end

        Set.new(indexes)
      end

      def self.collect_indexes_for(table, database, shard_name)
        sql = <<-SQL
          SELECT TABLE_NAME, INDEX_NAME, NON_UNIQUE,
                 SEQ_IN_INDEX, COLUMN_NAME, INDEX_TYPE
          FROM information_schema.statistics
          WHERE table_schema = '#{database}'
          AND table_name = '#{table}';
        SQL

        Stinger::Sharded::Utils
          .connection_for(:shard_name => shard_name)
          .execute(sql)
      end

      def self.database_for(shard_name)
        # I wish there was an easier way to get to this
        Stinger::Sharded::Utils \
          .connection_for(:shard_name => shard_name) \
          .instance_variable_get(:@config)[:database]
      end
    end
  end
end
