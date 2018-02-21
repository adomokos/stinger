require 'database_cleaner/active_record/transaction'

# rubocop:disable all
module DatabaseCleaner
  module ActiveRecord
    class Transaction
      def clean
        # AD added this code, see the original here:
        # https://github.com/DatabaseCleaner/database_cleaner/blob/master/lib/database_cleaner/active_record/transaction.rb#L29-L52
        connection_pool = if connection_class.respond_to?(:connection_pool)
                            connection_class.connection_pool
                          else
                            connection_class
                          end

        # This is the original code from DatabaseCleaner
        connection_pool.connections.each do |connection|
          next unless connection.open_transactions > 0

          if connection.respond_to?(:rollback_transaction)
            connection.rollback_transaction
          else
            connection.rollback_db_transaction
          end

          # The below is for handling after_commit hooks.. see https://github.com/bmabey/database_cleaner/issues/99
          if connection.respond_to?(:rollback_transaction_records, true)
            connection.send(:rollback_transaction_records, true)
          end

          next unless connection_maintains_transaction_count?
          if connection.respond_to?(:decrement_open_transactions)
            connection.decrement_open_transactions
          else
            connection_class.__send__(:decrement_open_transactions)
          end
        end
      end
    end
  end
end
# rubocop:enable all
