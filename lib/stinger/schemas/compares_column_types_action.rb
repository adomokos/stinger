module Stinger
  module Schemas
    class ComparesColumnTypesAction
      extend LightService::Action
      expects :compare_columns, :to_columns, :compare,
              :report, :table

      executed do |ctx|
        ctx.to_columns.length.times do |count|
          compare_column = ctx.compare_columns[count]
          to_column = ctx.to_columns[count]

          next if compare_column == to_column

          msg = "#{compare_column.fetch(:field)} for `#{ctx.compare}` " \
                "shard has `#{report_diff(compare_column, to_column)}` type diff(s)"
          ctx.report[ctx.table] << msg
        end
      end

      def self.report_diff(compare_column, to_column)
        type_diffs = compare_column.keys.each_with_object([]) do |key, diffs|
          next if compare_column[key] == to_column[key]

          diffs << key.to_s.titleize
        end

        type_diffs.join(', ')
      end
    end
  end
end
