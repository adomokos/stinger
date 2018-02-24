require 'spec_helper'

RSpec.describe Stinger::Endpoints::Asset do
  include_context 'set up sharded data'

  subject(:asset) do
    Stinger::Sharded::Asset.using(:client_3).first
  end

  it 'can find an asset with shard_id' do
    asset_shard_id = asset.shard_id

    located_asset_info = described_class.show(asset_shard_id)

    expect(located_asset_info.fetch(:id)).to eq(asset.id)
  end

  it 'returns an empty hash when asset is not found' do
    incorrect_shard_id =
      Stinger::Sharded::Utils
      .calculate_shard_id_from(100, asset.id) # Incorrect client id

    located_asset_info = described_class.show(incorrect_shard_id)

    expect(located_asset_info).to be_empty
  end
end
