FactoryBot.define do
    factory :organization do
        sequence(:name) { |n| "organization#{n}" }
        email { "#{name}@example.com" }
        phone { "555-123-4567" }
        status { :submitted }
        primary_name { "#{name}Primary" }
        secondary_name { "#{name}Secondary" }
        secondary_phone { "555-987-6543" }
        description { "This is a test organization." }
        transportation { :yes }
    
        agreement_one { true }
        agreement_two { true }
        agreement_three { true }
        agreement_four { true }
        agreement_five { true }
        agreement_six { true }
        agreement_seven { true }
        agreement_eight { true }
    end
end
  