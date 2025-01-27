require 'rails_helper'

RSpec.describe ResourceCategory, type: :model do

    let(:resource_category) { ResourceCategory.new }
    
    describe "attributes" do

        it "responds to name" do
            expect(resource_category).to respond_to(:name)
        end

        it "responde to active" do
            expect(resource_category).to respond_to(:active)
        end
    end

    describe "methods" do
        
        it "sets :active to true" do
            resource_category.activate
            expect(resource_category.active).to eq(true)
        end

        it "sets :active to false" do
            resource_category.deactivate
            expect(resource_category.active).to eq(false)
        end

        it "returns the name" do
            resource_category.name = "Test Name"
            expect(resource_category.name).to eq("Test Name")
        end

        describe "inactive?" do

            it "checks for true or false value in :active when :active is true" do
                resource_category.activate
                expect(resource_category.inactive?).to eq(false)
            end

            it "checks for true or false value in :active when :active is false" do
                resource_category.deactivate
                expect(resource_category.inactive?).to eq(true)
            end
        end

        describe "unspecified" do

            context "when unspecified category already exists" do
                it "returns the existing 'Unspecified' resource category" do
                    existing_category = ResourceCategory.create!(name: "Unspecified")
                    expect(ResourceCategory.unspecified).to eq(existing_category)
                end
            end
            
            context "when 'Unspecified' category does not exist" do
                it "creates and returns a new 'Unspecified' category" do
                    expect { ResourceCategory.unspecified }.to change {ResourceCategory.count}.by(1)
                    expect(ResourceCategory.last.name).to eq("Unspecified")
                end
            end
        end
    end

    describe "associations" do

        it "has_and_belongs_to_many organizations" do
            expect(ResourceCategory.reflect_on_association(:organizations).macro).to eq(:has_and_belongs_to_many)
        end

        it "has_many tickets" do
            expect(ResourceCategory.reflect_on_association(:tickets).macro).to eq(:has_many)
        end
    end

    describe 'length validations' do
        it "name" do
            should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create)
        end
    end

    describe 'unique validations' do
        it 'name' do
            should validate_uniqueness_of(:name).case_insensitive
        end
    end
end
