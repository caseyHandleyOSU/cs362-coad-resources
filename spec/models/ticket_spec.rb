require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:ticket) do
    region = Region.create!(name: "region1")
    resource = ResourceCategory.create!(name: "resource1")

    Ticket.create!(
      name: "ticket",
      phone: "+1-555-555-1212",
      region_id: region.id,
      resource_category_id: resource.id,
      closed: false
    )
  end

  let(:ticket_closed) do
    region = Region.create!(name: "region2")
    resource = ResourceCategory.create!(name: "resource2")

    Ticket.create!(
      name: "ticket",
      phone: "+1-555-555-1212",
      region_id: region.id,
      resource_category_id: resource.id,
      closed: true
    )
  end
    
  let(:ticket_org) do
    region = Region.create!(name: "region3")
    resource = ResourceCategory.create!(name: "resource3")
    org = Organization.create!(
      name: "myOrg1", email: "e@e.com", description: "", phone: "+15551234567",
      primary_name: "1", secondary_name: "1", secondary_phone: "+15551234567")

    Ticket.create!(
      name: "ticket",
      phone: "+1-555-555-1212",
      region_id: region.id,
      resource_category_id: resource.id,
      closed: false,
      organization_id: org.id
    )
  end

  describe "attributes" do

    it "has a name" do
      expect(ticket).to respond_to(:name)
    end

    it "has a description" do
      expect(ticket).to respond_to(:description)
    end

    it "has a phone number" do
      expect(ticket).to respond_to(:phone)
    end

    it "has a linked organization" do
      expect(ticket).to respond_to(:organization_id)
    end

    it "has a closed status" do
      expect(ticket).to respond_to(:closed)
    end

    it "has a closed date" do
      expect(ticket).to respond_to(:closed_at)
    end

    it "has a resource category" do
      expect(ticket).to respond_to(:resource_category_id)
    end

    it "has a region" do
      expect(ticket).to respond_to(:region)
    end

  end

  describe "associations" do

    it "should belong to a region" do
      should belong_to(:region)
    end

    it "should belong to a resource category" do
      should belong_to(:resource_category)
    end

    it "optionally belongs to an organization" do
      should belong_to(:organization).optional
    end

  end

  describe "validate presence of" do

    it "name" do 
      should validate_presence_of(:name)
    end

    it "phone" do 
      should validate_presence_of(:phone)
    end

    it "region id" do 
      should validate_presence_of(:region_id)
    end

    it "resource category id" do 
      should validate_presence_of(:resource_category_id)
    end

  end

  describe "validate length of" do

    it "name" do
      should validate_length_of(:name).
        is_at_least(1).
        is_at_most(255).
        on(:create)
    end

    it "description" do
      should validate_length_of(:description).
        is_at_most(1020).
        on(:create)
    end

  end

  describe "validate pattern of" do

    describe "phone" do

      it "valid" do
        expect(ticket).to allow_value("+15555551212").for(:phone)
        expect(ticket).to allow_value("15555551212").for(:phone)
        expect(ticket).to allow_value("+15554567890").for(:phone)
      end

      it "invalid" do
        expect(ticket).to_not allow_value("1").for(:phone)
        expect(ticket).to_not allow_value("1234567890").for(:phone)
        expect(ticket).to_not allow_value("5554567890").for(:phone)
      end

    end

  end

  describe "test static method" do

    it "open?" do
      expect(ticket.open?).to be_truthy() 
      expect(ticket_closed.open?).to be_falsy()
    end

    it "captured?" do
      expect(ticket.captured?).to be_falsy()
      expect(ticket_org.captured?).to be_truthy()
    end

    it "to_s" do
      expect(ticket.to_s).to eq("Ticket 1")
      expect(ticket_closed.to_s).to eq("Ticket 2")
      expect(ticket_org.to_s).to eq("Ticket 3")
    end

  end

  describe "scope of" do

    it "closed tickets" do
      expect(Ticket.closed).to include(ticket_closed)
      expect(Ticket.closed).not_to include(ticket)
      expect(Ticket.closed).not_to include(ticket_org)
    end

    it "open tickets" do
      expect(Ticket.open).to include(ticket)
      expect(Ticket.open).not_to include(ticket_closed)
      expect(Ticket.open).not_to include(ticket_org)
    end

    it "tickets with an organization" do
      expect(Ticket.all_organization).to include(ticket_org)
      expect(Ticket.all_organization).not_to include(ticket)
      expect(Ticket.all_organization).not_to include(ticket_closed)
    end

    it "open tickets for an organization" do
      expect(Ticket.organization(1)).to include(ticket_org)
      expect(Ticket.organization(1)).not_to include(ticket)
      expect(Ticket.organization(1)).not_to include(ticket_closed)
    end

    it "closed tickets for an organization" do
      expect(Ticket.closed_organization(1)).not_to include(ticket_org)
      expect(Ticket.closed_organization(1)).not_to include(ticket)
      expect(Ticket.closed_organization(1)).not_to include(ticket_closed)
      expect(Ticket.closed_organization(1)).to be_empty
    end

    it "all tickets for a region" do
      expect(Ticket.region(1)).to include(ticket)
      expect(Ticket.region(1)).not_to include(ticket_org)
      expect(Ticket.region(1)).not_to include(ticket_closed)
    end

    it "all tickets for a resource category" do
      expect(Ticket.resource_category(1)).to include(ticket)
      expect(Ticket.resource_category(1)).not_to include(ticket_org)
      expect(Ticket.resource_category(1)).not_to include(ticket_closed)
    end

  end

end
