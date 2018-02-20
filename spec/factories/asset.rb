FactoryBot.define do
  factory :asset, :class => Stinger::Asset do
    client_id CLIENT_ID

    trait :ip_address_locator do
      ip_address_locator '10.10.10.136'
    end

    trait :hostname_locator do
      hostname_locator 'ip-72-55-176-42.static.privatedns.com'
    end
  end
end
