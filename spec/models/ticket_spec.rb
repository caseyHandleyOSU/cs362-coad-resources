require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe "attributes" do
    before(:each) do
      @ticket = FactoryBot.build_stubbed(:ticket_open)
    end

    it "has a name" do
      expect(@ticket).to respond_to(:name)
    end

    it "has a description" do
      expect(@ticket).to respond_to(:description)
    end

    it "has a phone number" do
      expect(@ticket).to respond_to(:phone)
    end

    it "has a linked organization" do
      expect(@ticket).to respond_to(:organization_id)
    end

    it "has a closed status" do
      expect(@ticket).to respond_to(:closed)
    end

    it "has a closed date" do
      expect(@ticket).to respond_to(:closed_at)
    end

    it "has a resource category" do
      expect(@ticket).to respond_to(:resource_category_id)
    end

    it "has a region" do
      expect(@ticket).to respond_to(:region)
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

    before(:each) do
      @ticket = FactoryBot.build_stubbed(:ticket_open)
    end

    describe "phone number" do

      it "valid" do
        expect(@ticket).to allow_value("+15555551212").for(:phone)
        expect(@ticket).to allow_value("15555551212").for(:phone)
        expect(@ticket).to allow_value("+15554567890").for(:phone)
      end

      it "invalid" do
        expect(@ticket).to_not allow_value("1").for(:phone)
        expect(@ticket).to_not allow_value("1234567890").for(:phone)
        expect(@ticket).to_not allow_value("5554567890").for(:phone)
      end

    end

  end

  describe "test static method" do

    before(:each) do
      @open_ticket = FactoryBot.build_stubbed(:ticket_open)
    end

    it "open?" do
      closed_ticket = FactoryBot.build_stubbed(:ticket_closed)

      expect(@open_ticket.open?).to be_truthy() 
      expect(closed_ticket.open?).to be_falsy()
    end

    it "captured?" do
      org = FactoryBot.create(:organization)
      org_ticket = FactoryBot.build_stubbed(
        :ticket_open, 
        organization_id: org.id
      )

      expect(@open_ticket.captured?).to be_falsy()
      expect(org_ticket.captured?).to be_truthy()
    end

    it "to_s" do
      ticket_1 = FactoryBot.build_stubbed(:ticket_open, name: "Ticket 1", id: 1)
      ticket_2 = FactoryBot.build_stubbed(:ticket_closed, name: "Ticket 2", id: 2)

      expect(ticket_1.to_s).to eq("Ticket 1")
      expect(ticket_2.to_s).to eq("Ticket 2")
    end

  end

  describe "scope of" do
    before(:each) do
      @org = FactoryBot.create(:organization)
      @reg = FactoryBot.create(:region)
      @cat = FactoryBot.create(:resource_category)

      @open_ticket = FactoryBot.create(:ticket_open,
        region_id: @reg.id,
        resource_category_id: @cat.id
      )
      @closed_ticket = FactoryBot.create(:ticket_closed,
        region_id: @reg.id,
        resource_category_id: @cat.id
      )
      @org_ticket = FactoryBot.create(
        :ticket_open, 
        organization_id: @org.id,
        region_id: @reg.id,
        resource_category_id: @cat.id
      )
    end

    it "closed tickets" do
      expect(Ticket.closed).to include(@closed_ticket)
      expect(Ticket.closed).not_to include(@open_ticket)
      expect(Ticket.closed).not_to include(@org_ticket)
    end

    it "open tickets" do
      
      expect(Ticket.open).to include(@open_ticket)
      expect(Ticket.open).not_to include(@closed_ticket)
      expect(Ticket.open).not_to include(@org_ticket)
    end

    it "tickets with an organization" do
      expect(Ticket.all_organization).to include(@org_ticket)
      expect(Ticket.all_organization).not_to include(@open_ticket)
      expect(Ticket.all_organization).not_to include(@closed_ticket)
    end

    it "open tickets for an organization" do
      expect(Ticket.organization(@org.id)).to include(@org_ticket)
      expect(Ticket.organization(@org.id)).not_to include(@open_ticket)
      expect(Ticket.organization(@org.id)).not_to include(@closed_ticket)
    end

    it "closed tickets for an organization" do
      expect(Ticket.closed_organization(@org.id)).not_to include(@org_ticket)
      expect(Ticket.closed_organization(@org.id)).not_to include(@open_ticket)
      expect(Ticket.closed_organization(@org.id)).not_to include(@closed_ticket)
      expect(Ticket.closed_organization(@org.id)).to be_empty
    end

    it "all tickets for a region" do
      expect(Ticket.region(@reg.id)).to include(@open_ticket)
      expect(Ticket.region(@reg.id)).to include(@org_ticket)
      expect(Ticket.region(@reg.id)).to include(@closed_ticket)
    end

    it "all tickets for a resource category" do
      expect(Ticket.resource_category(@cat.id)).to include(@open_ticket)
      expect(Ticket.resource_category(@cat.id)).to include(@org_ticket)
      expect(Ticket.resource_category(@cat.id)).to include(@closed_ticket)
    end

  end

end
