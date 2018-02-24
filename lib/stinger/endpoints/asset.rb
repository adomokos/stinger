module Stinger
  module Endpoints
    class Asset
      def self.show(shard_id)
        client_id, asset_id =
          Stinger::Sharded::Utils.ids_from_shard_id(shard_id)

        shard_name = Stinger::Sharded::Utils.shard_name_for(client_id)

        asset =
          Stinger::Sharded::Asset
          .using(shard_name)
          .find_by(:id => asset_id)

        return {} unless asset

        asset.attributes.with_indifferent_access
      end
    end
  end
end
