FactoryBot.define do
  factory :ticket do
    name { "Test Ticket" }
    phone { "+15553456789" }
    description { "Test description" }
    closed { false }
    association :region
    association :resource_category

    trait :closed do
      closed { true }
    end

    trait :assigned do
      association :organization
    end
  end
end
