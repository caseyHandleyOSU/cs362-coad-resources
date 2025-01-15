require 'rails_helper'

RSpec.describe Region, type: :model do

  describe "attributes" do

    it "has a name" do
      region = Region.new
      expect(region).to respond_to(:name)
    end

    it "has a string representation that is its name" do
      name = 'Mt. Hood'
      region = Region.new(name: name)
      result = region.to_s
    end

  end

  describe "associations" do

    it "has many tickets" do 
      should have_many(:tickets)
    end
  
  end

end
