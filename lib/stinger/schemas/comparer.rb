module Stinger
  module Schemas
    class Comparer
      extend LightService::Organizer

      # to: is the baseline
      # compare: is the one we compare to the baseline
      def self.call(compare:, to:)
        with(:compare => compare,
             :to => to,
             :report => {})
          .reduce(actions)
      end

      def self.actions
        [
          PullsTableNamesAction,
          iterate(:tables, [
                    ReadsFieldsAction,
                    ComparesNumberOfColumnsAction,
                    ComparesColumnOrderAction,
                    ComparesColumnTypesAction,
                    ReadsIndexesAction,
                    ComparesIndexesAction
                  ])
        ]
      end
    end
  end
end
