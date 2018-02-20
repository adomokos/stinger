require 'spec_helper'

RSpec.describe Stinger::Sharded::Asset do
  before do
    # ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  subject(:asset) do
    Octopus.using(:client_3) do
      FactoryBot.create(:asset,
                        :ip_address_locator,
                        :client_id => SHARDED_CLIENT_ID)
    end
  end

  it 'has many vulnerabilities' do
    cve = FactoryBot.create(:cve, :apple)
    Octopus.using(:client_3) do
      FactoryBot.create(:vulnerability,
                        :client_id => SHARDED_CLIENT_ID,
                        :asset => asset,
                        :cve => cve)
    end

    asset_count =
      Stinger::Sharded::Asset
      .using(:client_3)
      .count

    expect(asset_count).to eq(1)
  end
end
