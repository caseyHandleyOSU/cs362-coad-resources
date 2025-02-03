
FactoryBot.define do

  sequence :name do |n|
    "region #{n}"
  end

  factory :region do
    name 
  end

end