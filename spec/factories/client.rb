FactoryBot.define do
  factory :client, :class => Stinger::Client do
    id CLIENT_ID
    sequence(:name) { |n| "Test Client #{n}" }
    sequence(:subdomain) { |n| "testclient#{n}" }

    trait :sharded do
      id SHARDED_CLIENT_ID
      sequence(:name) { |n| "Sharded Test Client #{n}" }
      sequence(:subdomain) { |n| "sharded-testclient#{n}" }
    end
  end
end
