FactoryBot.define do

  sequence :ticket_name do |n|
    "ticket #{n}"
  end

  factory :ticket do

    name      { generate(:ticket_name) }
    phone     { "+1-555-555-1212" }

    region
    resource_category
    
    factory :ticket_closed do
      closed { true }
    end

    factory :ticket_open do
      closed { false }
    end

    trait :with_region do
      region_id { create(:region).id }
    end

    trait :with_category do
      resource_category_id { create(:resource_category).id }
    end

  end

end