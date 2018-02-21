require 'spec_helper'

RSpec.describe Stinger::Sharded::Asset do
  before do
    apple_cve = FactoryBot.create(:cve, :apple)
    oracle_cve = FactoryBot.create(:cve, :oracle)
    FactoryBot.create(:client, :sharded)

    Octopus.using(:client_3) do
      asset = FactoryBot.create(:asset,
                                :ip_address_locator,
                                :client_id => SHARDED_CLIENT_ID)

      FactoryBot.create(:vulnerability,
                        :client_id => SHARDED_CLIENT_ID,
                        :asset => asset,
                        :cve_id => apple_cve.id)

      FactoryBot.create(:vulnerability,
                        :client_id => SHARDED_CLIENT_ID,
                        :asset => asset,
                        :cve_id => oracle_cve.id)
    end
  end

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
