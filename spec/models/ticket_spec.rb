require 'rails_helper'

RSpec.describe ResourceCategory, type: :model do
  let(:resource_category) { build(:resource_category) } 

  describe "attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:active) }
  end

  describe "methods" do
    it "activates the category" do
      resource_category.activate
      expect(resource_category.active).to be true
    end

    it "deactivates the category" do
      resource_category.deactivate
      expect(resource_category.active).to be false
    end

    it "returns the name as string representation" do
      resource_category.name = "Test Name"
      expect(resource_category.to_s).to eq("Test Name")
    end

    describe "#inactive?" do
      it "returns false when active is true" do
        resource_category.activate
        expect(resource_category.inactive?).to be false
      end

      it "returns true when active is false" do
        resource_category.deactivate
        expect(resource_category.inactive?).to be true
      end
    end

    describe ".unspecified" do
      context "when 'Unspecified' category already exists" do
        it "returns the existing 'Unspecified' resource category" do
          existing_category = create(:resource_category, name: "Unspecified")
          expect(ResourceCategory.unspecified).to eq(existing_category)
        end
      end

      context "when 'Unspecified' category does not exist" do
        it "creates and returns a new 'Unspecified' category" do
          expect { ResourceCategory.unspecified }.to change { ResourceCategory.count }.by(1)
          expect(ResourceCategory.last.name).to eq("Unspecified")
        end
      end
    end
  end

  describe "associations" do
    it { should have_and_belong_to_many(:organizations) }
    it { should have_many(:tickets) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe "scopes" do
    let!(:active_category) { create(:resource_category, name: "Active Category", active: true) }
    let!(:inactive_category) { create(:resource_category, name: "Inactive Category", active: false) }

    it "returns active categories" do
      expect(ResourceCategory.active).to include(active_category)
      expect(ResourceCategory.active).not_to include(inactive_category)
    end

    it "returns inactive categories" do
      expect(ResourceCategory.inactive).to include(inactive_category)
      expect(ResourceCategory.inactive).not_to include(active_category)
    end
  end
end