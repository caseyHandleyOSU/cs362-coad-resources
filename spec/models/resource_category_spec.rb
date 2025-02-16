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

  describe "test static methods" do

    it "unspecified" do
      unspecifiedResource = ResourceCategory.find_or_create_by(name: 'Unspecified')
      expect(ResourceCategory.unspecified).to eq(unspecifiedResource)
    end

    it "activate" do
      r = FactoryBot.create(:inactive_resource)
      r.activate
      expect(r.active).to be_truthy
    end

    it "deactivate" do
      r = FactoryBot.create(:active_resource)
      r.deactivate
      expect(r.active).to be_falsy
    end

    it "inactive?" do
      active = FactoryBot.build_stubbed(:active_resource)
      inactive = FactoryBot.build_stubbed(:inactive_resource)

      expect(active.inactive?).to be_falsy
      expect(inactive.inactive?).to be_truthy
    end

    it "to_s" do
      active    = FactoryBot.build_stubbed(:active_resource, name: "Active")
      inactive  = FactoryBot.build_stubbed(:inactive_resource, name: "Inactive")

      expect(active.to_s).to eq("Active")
      expect(inactive.to_s).to eq("Inactive")
    end

  end

  describe "test scope of" do

    it "active" do
      active    = FactoryBot.create(:active_resource, name: "Active")
      inactive  = FactoryBot.create(:inactive_resource, name: "Inactive")
      
      expect(ResourceCategory.active).to include(active)
      expect(ResourceCategory.active).not_to include(inactive)
    end

    it "inactive" do
      active    = FactoryBot.create(:active_resource, name: "Active")
      inactive  = FactoryBot.create(:inactive_resource, name: "Inactive")
      
      expect(ResourceCategory.inactive).to include(inactive)
      expect(ResourceCategory.inactive).not_to include(active)
    end

  end

end
