require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:ticket) { Ticket.new }

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

end
