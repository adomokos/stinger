class AddClientIdIndexToAssets < ActiveRecord::Migration[5.0]
  using_all_shards

  def change
    idx_name = 'index_assets_on_client_id'
    # Don't apply it to shards where this index exists
    return if index_exists?(:assets,
                            :client_id,
                            :name => idx_name)

    add_index(:assets, :client_id, :name => idx_name)
  end
end
