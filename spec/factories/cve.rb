FactoryBot.define do
  factory :cve do
    trait :apple do
      identifier 'CVE-2014-0064'
      summary 'Multiple integer overflows in the path_in'
      references ':source: APPLE'
      risk_meter_score 29.3125
    end

    trait :oracle do
      identifier 'CVE-2017-3623'
      summary 'Vulnerability in Solaris'
      references ':source: ORACLE'
    end
  end
end
