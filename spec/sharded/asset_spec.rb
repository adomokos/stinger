require 'spec_helper'

RSpec.describe Stinger::Sharded::Asset do
  before do
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    cve = FactoryBot.create(:cve, :apple)
    FactoryBot.create(:client, :sharded)
    Octopus.using(:client_3) do
      asset = FactoryBot.create(:asset,
                                :ip_address_locator,
                                :client_id => SHARDED_CLIENT_ID)
      FactoryBot.create(:vulnerability,
                        :client_id => SHARDED_CLIENT_ID,
                        :asset => asset,
                        :cve_id => cve.id)
    end
  end

  subject(:asset) do
    Stinger::Sharded::Asset.using(:client_3).first
  end

  it 'has many vulnerabilities' do
    asset_count =
      Stinger::Sharded::Asset
      .using(:client_3)
      .count

    expect(asset_count).to eq(1)
  end

  it "can find it's client" do
    expect(asset.client).not_to be_nil
  end
end
