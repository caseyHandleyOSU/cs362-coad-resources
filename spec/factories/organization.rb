FactoryBot.define do
    factory :organization do
        name { "Test Organization" }
        email { "test@example.com" }
        phone { "555-123-4567" }
        status { :submitted }
        primary_name { "Primary Contact" }
        secondary_name { "Secondary Contact" }
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
  