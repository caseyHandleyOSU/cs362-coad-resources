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
end
