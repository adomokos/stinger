require 'spec_helper'

RSpec.describe Client do
  it 'has a hard-coded id - 3' do
    client = FactoryBot.create(:client)

    expect(client.id).to eq(3)
  end
end
