require 'spec_helper'

RSpec.describe Asset do
  subject(:asset) do
    FactoryBot.create(:asset, :ip_address_locator)
  end

  it 'has many vulnerabilities' do
    cve = FactoryBot.create(:cve, :apple)
    vuln1 = FactoryBot.create(:vulnerability,
                              :client_id => CLIENT_ID,
                              :asset => asset,
                              :cve => cve)

    expect(vuln1).to be_persisted
  end
end
