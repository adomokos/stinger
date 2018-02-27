module Stinger
  module Sharded
    class Base < ActiveRecord::Base
      self.abstract_class = true

      SHARDED_METHODS = %i[all count find find_by find_or_initialize_by
                           first last new second update where bulk_insert].freeze

      SHARDED_METHODS.each do |m|
        singleton_class.send(:alias_method, "#{m}_old", m)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def self.#{m}(*args, &block)
            result = self.shard.#{m}_old(*args, &block)
            @used_shard = nil
            result
          end
        RUBY
      end

      singleton_class.send(:alias_method, :using_octopus, :using)

      def self.shard
        using_octopus(selected_shard)
      end

      def self.using(shard_name)
        @used_shard = shard_name.to_sym
        self
      end

      def self.selected_shard
        return @used_shard if @used_shard

        Stinger::Sharded::Utils.shard_name_for(current_client_id)
      end

      def self.current_client_id
        Thread.current[:client_id]
      end

      # Original ideas are from the Pinterest sharding blog post: https://goo.gl/7HwBXQ
      def shard_id
        return nil unless persisted?

        Stinger::Sharded::Utils.calculate_shard_id_from(client_id, id)
      end
    end
  end
end
