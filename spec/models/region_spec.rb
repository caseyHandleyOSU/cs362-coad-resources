require 'rails_helper'

RSpec.describe Region, type: :model do

  describe "attributes" do

    it "has a name" do
      region = Region.new
      expect(region).to respond_to(:name)
    end

    it "has a string representation that is its name" do
      name = 'Mt. Hood'
      region = FactoryBot.build_stubbed(:region, name: name)
      result = region.to_s
    end

  end

  describe "associations" do

    it "has many tickets" do 
      should have_many(:tickets)
    end
  
  end

  describe "validate presence of" do

    it "name" do 
      should validate_presence_of(:name)
    end

  end

  describe "validate length of" do

    it "name" do
      should validate_length_of(:name).
        is_at_least(1).
        is_at_most(255).
        on(:create)
    end

  end

  describe "validate uniqueness of" do

    it "name" do
      should validate_uniqueness_of(:name).
        case_insensitive()
    end

  end

  describe "test static method" do

    it "unspecified" do
      expect(Region.unspecified).to eq(Region.find_or_create_by(name: 'Unspecified'))
    end

    it "to_s" do
      name = "Hello, World"
      region = FactoryBot.build_stubbed(:region, name: name)
      expect(region.to_s).to eq(name)
    end

  end

end
