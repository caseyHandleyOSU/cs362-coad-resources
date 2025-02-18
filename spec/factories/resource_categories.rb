FactoryBot.define do
  factory :resource_category do
    sequence(:name) { |n| "resource category #{n}" }

    factory :inactive_resource do
      active { false }
    end

    factory :active_resource do
      active { true }
    end
  end
end
  