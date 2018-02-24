require 'spec_helper'

RSpec.describe Stinger::Client do
  include_context 'set up sharded data'
  subject(:client) do
    FactoryBot.create(:client)
  end

  let!(:asset) do
    FactoryBot.create(:sharded_asset,
                      :ip_address_locator,
                      :client_id => CLIENT_ID)
  end

  it 'has a hard-coded id - 2' do
    expect(client.id).to eq(CLIENT_ID)
  end

  it 'has many sharded assets' do
    asset2 = FactoryBot.create(:sharded_asset,
                               :hostname_locator,
                               :client_id => CLIENT_ID)

    expect(client.assets).to match_array([asset, asset2])
  end

  it 'has many sharded vulns' do
    vuln1 = FactoryBot.create(:sharded_vulnerability,
                              :client_id => client.id,
                              :asset => asset,
                              :cve_id => apple_cve.id)
    vuln2 = FactoryBot.create(:sharded_vulnerability,
                              :client_id => client.id,
                              :asset => asset,
                              :cve_id => apple_cve.id)

    expect(client.vulnerabilities).to match_array([vuln1, vuln2])
  end
end
