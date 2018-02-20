FactoryBot.define do
  factory :client do
    id 3
    sequence(:name) { |n| "Test Client #{n}" }
    sequence(:subdomain) { |n| "testclient#{n}" }
  end
end
