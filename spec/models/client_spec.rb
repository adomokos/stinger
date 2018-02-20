require 'spec_helper'

RSpec.describe Stinger::Client do
  subject(:client) do
    FactoryBot.create(:client)
  end

  it 'has a hard-coded id - 3' do
    expect(client.id).to eq(CLIENT_ID)
  end

  it 'has many assets' do
    asset1 = FactoryBot.create(:asset, :ip_address_locator)
    asset2 = FactoryBot.create(:asset, :hostname_locator)

    client.reload

    expect(client.assets).to match_array([asset1, asset2])
  end
end
