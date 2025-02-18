FactoryBot.define do

  factory :ticket do
    sequence(:name) { |n| "ticket #{n}" }
    phone { "+15553456789" }
    description { "Test description" }
    region
    resource_category

    factory :ticket_closed do
      closed { true }
    end

    factory :ticket_open do
      closed {false}
    end

    trait :with_region do
      region_id { create(:region).id }
    end

    trait :with_category do
      resource_category_id { create(:resource_category).id }
    end
  end
end
