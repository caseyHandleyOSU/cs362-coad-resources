require 'rails_helper'

RSpec.describe ResourceCategory, type: :model do
  let(:inactive_resource) { ResourceCategory.new(name: "Inactive", active: false) }
  let(:active_resource) { ResourceCategory.new(name: "Active", active: true) }


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
      inactive_resource.activate
      expect(inactive_resource.active).to be_truthy
    end

    it "deactivate" do
      active_resource.deactivate
      expect(active_resource.active).to be_falsy
    end

    it "inactive?" do
      expect(active_resource.inactive?).to be_falsy
      expect(inactive_resource.inactive?).to be_truthy
    end

    it "to_s" do
      expect(active_resource.to_s).to eq("Active")
      expect(inactive_resource.to_s).to eq("Inactive")
    end

  end

end
