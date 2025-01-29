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

    describe 'scope' do
        let!(:region1) { Region.create!(name: "Region 1") }
        let!(:region2) { Region.create!(name: "Region 2") }
        let!(:resource_category1) { ResourceCategory.create!(name: "Category 1") }
        let!(:resource_category2) { ResourceCategory.create!(name: "Category 2") }
        let!(:organization1) { Organization.create!(name: "Org 1") }
        let!(:organization2) { Organization.create!(name: "Org 2") }

        let!(:organization1) do
            Organization.create!(
              name: "Org 1",
              email: "org1@example.com",
              phone: "+15551234567",
              primary_name: "Primary Contact 1",
              secondary_name: "Secondary Contact 1",
              secondary_phone: "+15557654321"
            )
        end
          
          let!(:organization2) do
            Organization.create!(
              name: "Org 2",
              email: "org2@example.com",
              phone: "+15559876543",
              primary_name: "Primary Contact 2",
              secondary_name: "Secondary Contact 2",
              secondary_phone: "+15553456789"
            )
        end
          

        let!(:open_ticket) do
            Ticket.create!(
              name: "Open Ticket",
              phone: "+15553456789",
              description: "Test description",
              region: region1,
              resource_category: resource_category1,
              closed: false,
              organization: nil
            )
        end
        
        let!(:closed_ticket) do
            Ticket.create!(
              name: "Closed Ticket",
              phone: "+15553456789",
              description: "Test description",
              region: region1,
              resource_category: resource_category1,
              closed: true,
              organization: nil
            )
        end
        
        let!(:assigned_ticket) do
            Ticket.create!(
              name: "Assigned Ticket",
              phone: "+15553456789",
              description: "Test description",
              region: region1,
              resource_category: resource_category1,
              closed: false,
              organization: organization1
            )
        end
        
        let!(:closed_assigned_ticket) do
            Ticket.create!(
              name: "Closed Assigned Ticket",
              phone: "+15553456789",
              description: "Test description",
              region: region1,
              resource_category: resource_category1,
              closed: true,
              organization: organization1
            )
        end

        it "returns only open tickets" do
            expect(Ticket.open).to include(open_ticket)
            expect(Ticket.open).not_to include(closed_ticket)
            expect(Ticket.open).not_to include(assigned_ticket)
        end
      
        it "returns only closed tickets" do
            expect(Ticket.closed).to include(closed_ticket, closed_assigned_ticket)
            expect(Ticket.closed).not_to include(open_ticket, assigned_ticket)
        end
      
        it "returns all assigned (non-closed) organization tickets" do
            expect(Ticket.all_organization).to include(assigned_ticket)
            expect(Ticket.all_organization).not_to include(open_ticket, closed_ticket, closed_assigned_ticket)
        end
      
        it "returns open tickets for a specific organization" do
            expect(Ticket.organization(organization1.id)).to include(assigned_ticket)
            expect(Ticket.organization(organization1.id)).not_to include(open_ticket, closed_assigned_ticket, closed_ticket)
        end
      
        it "returns closed tickets for a specific organization" do
            expect(Ticket.closed_organization(organization1.id)).to include(closed_assigned_ticket)
            expect(Ticket.closed_organization(organization1.id)).not_to include(open_ticket, assigned_ticket, closed_ticket)
        end
      
        it "returns tickets belonging to a specific region" do
            ticket1 = Ticket.create!(name: "Ticket in Region2", phone: "+15553456789", description: "Desc", region: region2, resource_category: resource_category1, closed: false)
            expect(Ticket.region(region2.id)).to include(ticket1)
            expect(Ticket.region(region2.id)).not_to include(open_ticket, closed_ticket)
        end
      
        it "returns tickets belonging to a specific resource category" do
            ticket1 = Ticket.create!(name: "Ticket in Category2", phone: "+15553456789", description: "Desc", region: region1, resource_category: resource_category2, closed: false)
            expect(Ticket.resource_category(resource_category2.id)).to include(ticket1)
            expect(Ticket.resource_category(resource_category2.id)).not_to include(open_ticket, closed_ticket)
        end
    end


end
