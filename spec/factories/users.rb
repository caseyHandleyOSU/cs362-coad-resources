FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com"}
    password { "password123" }

    before(:create) { |user| user.skip_confirmation! }
      
    trait :admin do
      role { :admin }
    end
  end
end
