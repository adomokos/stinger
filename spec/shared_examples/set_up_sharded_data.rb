RSpec.shared_context 'set up sharded data' do
  let!(:sharded_client) { FactoryBot.create(:client, :sharded) }
  let!(:apple_cve) { FactoryBot.create(:cve, :apple) }
  let!(:oracle_cve) { FactoryBot.create(:cve, :oracle) }
  let(:sharded_asset) do
    FactoryBot.create(:asset,
                      :ip_address_locator,
                      :client_id => sharded_client.id)
  end

  before do
    # ActiveRecord::Base.logger = Logger.new(STDOUT)
    Octopus.using(:client_3) do
      FactoryBot.create(:vulnerability,
                        :client_id => sharded_client.id,
                        :asset => sharded_asset,
                        :cve_id => apple_cve.id)

      FactoryBot.create(:vulnerability,
                        :client_id => sharded_client.id,
                        :asset => sharded_asset,
                        :cve_id => oracle_cve.id)
    end
  end
end
