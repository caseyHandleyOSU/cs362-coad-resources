FactoryBot.define do

  sequence :user_email do |n|
    "user#{n}@user.com"
  end

  factory :user do

    email     { generate(:user_email) }
    password  { "wowASecurePassword" }

    before(:create) { |user| user.skip_confirmation! }

    trait :admin do
      role { :admin }
    end

  end

end