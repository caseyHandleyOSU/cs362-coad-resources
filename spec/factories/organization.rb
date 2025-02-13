FactoryBot.define do

  sequence :org_name do |n|
    "organization_#{n}"
  end

  factory :organization do
    name            { generate(:org_name) }
    email           { "#{name}@email.com" }
    description     { "A generic description" }
    phone           { "+15551234567" }
    primary_name    { "#{name}_primary "}
    secondary_name  { "#{name}_secondary "}
    secondary_phone { "+15551234567" }
    
    trait :approved do
      status { :approved }
    end

    trait :unapproved do
      status { :submitted }
    end

  end

end