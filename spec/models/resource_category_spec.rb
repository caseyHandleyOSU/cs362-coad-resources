require 'rails_helper'

RSpec.describe ResourceCategory, type: :model do

  describe "associations" do

    it "has and belongs to many organizations" do
      should have_and_belong_to_many(:organizations)
    end

    it "should have many tickets" do
      should have_many(:tickets)
    end

  end

  describe "validate presence of" do

    it "name" do 
      should validate_presence_of(:name)
    end

  end
end
