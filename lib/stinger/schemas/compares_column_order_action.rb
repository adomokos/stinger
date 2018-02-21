module Stinger
  module Schemas
    class ComparesColumnOrderAction
      extend LightService::Action
      expects :compare_columns, :to_columns, :compare,
              :report, :table

      executed do |ctx|
        ctx.to_columns.length.times do |count|
          to_column = ctx.to_columns[count].fetch(:field)
          compare_column = ctx.compare_columns[count].fetch(:field)

          next if to_column == compare_column

          msg = "#{compare_column} for `#{ctx.compare}` shard is out of order"
          ctx.report[ctx.table] << msg

          break # only record the first out of order column
        end
      end
    end
  end
end
