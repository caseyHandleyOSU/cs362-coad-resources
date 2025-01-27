require 'rails_helper'

RSpec.describe Ticket, type: :model do

    let(:ticket) { Ticket.new }

    describe "attributes" do

        it "responds to name" do
            expect(ticket).to respond_to(:name)
        end

        it "responds to description" do
            expect(ticket).to respond_to(:description)
        end

        it "responds to phone" do
            expect(ticket).to respond_to(:phone)
        end

        it "responds to organization_id" do
            expect(ticket).to respond_to(:organization_id)
        end

        it "responds to closed" do
            expect(ticket).to respond_to(:closed)
        end

        it "responds to closed_at" do
            expect(ticket).to respond_to(:closed_at)
        end

        it "responds to resource_category_id" do
            expect(ticket).to respond_to(:resource_category_id)
        end

        it "responds to region_id" do
            expect(ticket).to respond_to(:region_id)
        end
    end

    describe "associations" do

        it "belongs_to region" do
            expect(Ticket.reflect_on_association(:region).macro).to eq(:belongs_to)
        end

        it "belongs_to resource_category" do
            expect(Ticket.reflect_on_association(:resource_category).macro).to eq(:belongs_to)
        end

        it "belongs_to organization" do
            expect(Ticket.reflect_on_association(:organization).macro).to eq(:belongs_to)
        end
    end

    describe "methods" do

        it 'returns the string "Ticket #{id}"' do
            ticket = Ticket.create!(
                name: 'Test Ticket',
                phone: '(450) 456-7890',
                region: Region.create!(name: 'Test Region'),
                resource_category: ResourceCategory.create!(name: 'Test Resource Category')
            )
            expect(ticket.to_s).to eq("Ticket #{ticket.id}")
        end
    end

    describe 'length validations' do
        it 'name' do
            should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create)
        end

        it 'description' do
            should validate_length_of(:description).is_at_most(1020).on(:create)
        end
    end

    describe 'phone validations' do
        it 'valid' do
            expect(ticket).to allow_value("+3605899862").for(:phone)
            expect(ticket).to allow_value("3605899862").for(:phone)
        end

        it 'invalid' do
            expect(ticket).to_not allow_value('2').for(:phone)
            expect(ticket).to_not allow_value("1234567890").for(:phone)
        end
    end
end
