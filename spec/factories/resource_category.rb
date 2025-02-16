FactoryBot.define do

  sequence :category_name do |n|
    "resource category #{n}"
  end

  factory :resource_category do

    name      { generate(:category_name) }
    
    factory :inactive_resource do
      active { false }
    end

    factory :active_resource do
      active { true }
    end

  end

end