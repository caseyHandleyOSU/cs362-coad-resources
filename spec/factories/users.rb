FactoryBot.define do
    factory :user do
      email { "test@example.com" }
      password { "password123" }
      password_confirmation { "password123" }
      confirmed_at { Time.now } # Required for Devise confirmable
  
      trait :admin do
        role { :admin }
      end
  
      trait :organization do
        role { :organization }
      end
    end
  end
  