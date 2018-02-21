module Stinger
  module Schemas
    class ComparesNumberOfColumnsAction
      extend LightService::Action
      expects :compare_columns, :to_columns, :compare, :report, :table

      executed do |ctx|
        next ctx if ctx.compare_columns.length == ctx.to_columns.length

        if ctx.compare_columns.length < ctx.to_columns.length
          missing_columns = column_names_from(ctx.to_columns) -
                            column_names_from(ctx.compare_columns)

          msg = "#{missing_columns.join(', ')} " \
                "field(s) for `#{ctx.compare}` shard are missing"
          ctx.report[ctx.table] << msg
        end

        if ctx.compare_columns.length > ctx.to_columns.length
          extra_columns = column_names_from(ctx.compare_columns) -
                          column_names_from(ctx.to_columns)

          msg = "#{extra_columns.join(', ')} " \
                "field(s) for `#{ctx.compare}` shard are extra"
          ctx.report[ctx.table] << msg
        end

        ctx.skip_remaining!
      end

      def self.column_names_from(columns)
        columns.map do |column|
          column.fetch(:field)
        end
      end
    end
  end
end
