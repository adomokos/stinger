module Stinger
  module Schemas
    class ComparesIndexesAction
      extend LightService::Action
      expects :compare_indexes, :to_indexes, :compare, :to, :report, :table

      executed do |ctx|
        compare_diffs = compare_indexes(ctx.compare_indexes, ctx.to_indexes)

        if compare_diffs.any?
          ctx.report[ctx.table] += report_diffs(compare_diffs, ctx.compare, ctx.to)
        end

        to_diffs = compare_indexes(ctx.to_indexes, ctx.compare_indexes)

        ctx.report[ctx.table] += report_diffs(to_diffs, ctx.to, ctx.compare) if to_diffs.any?

        index_diffs = ctx.compare_indexes - ctx.to_indexes
        ctx.report[ctx.table] += report_type_diffs(index_diffs, ctx.compare) if index_diffs.any?
      end

      def self.compare_indexes(from, to)
        extract_idx_name_and_column(from) - \
          extract_idx_name_and_column(to)
      end

      def self.report_diffs(diffs, from, to)
        diffs.to_a.map do |diff|
          "index `#{diff.fetch(:index_name)}` on `#{diff.fetch(:column_name)}` " \
          "is in :#{from} but not in :#{to}"
        end
      end

      def self.report_type_diffs(diffs, from)
        diffs.to_a.map do |diff|
          "index `#{diff.fetch(:index_name)}` on `#{diff.fetch(:column_name)}` " \
          "is different in :#{from}"
        end
      end

      def self.extract_idx_name_and_column(indexes)
        indexes.to_a.map do |idx|
          { :index_name => idx.fetch(:index_name),
            :column_name => idx.fetch(:column_name) }
        end
      end
    end
  end
end
