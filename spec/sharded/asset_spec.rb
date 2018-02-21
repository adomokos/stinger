require 'spec_helper'

RSpec.describe Stinger::Sharded::Asset do
  include_context 'set up sharded data'

  subject(:asset) do
    Stinger::Sharded::Asset.using(:client_3).first
  end

  it 'has 1 asset in the DB' do
    asset_count =
      Stinger::Sharded::Asset
      .using(:client_3)
      .count

    expect(asset_count).to eq(1)
  end

  it 'has two vulnerabilities' do
    expect(asset.vulnerabilities.count).to eq(2)
  end

  it "can find it's client" do
    expect(asset.client).not_to be_nil
  end
end
