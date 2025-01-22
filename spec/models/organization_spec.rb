require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:org) { Organization.new }


  describe "attributes" do

    it "has a name" do
      expect(org).to respond_to(:name)
    end

    it "has a status" do
      expect(org).to respond_to(:status)
    end

    it "has a phone number" do
      expect(org).to respond_to(:phone)
    end
    
    it "has an email" do
      expect(org).to respond_to(:email)
    end
    
    it "has a description" do
      expect(org).to respond_to(:description)
    end

    it "has a rejection reason" do
      expect(org).to respond_to(:rejection_reason)
    end

    it "has liability insurance" do
      expect(org).to respond_to(:liability_insurance)
    end

    it "has a primary contact name" do
      expect(org).to respond_to(:primary_name)
    end

    it "has a secondary contact name" do
      expect(org).to respond_to(:secondary_name)
    end

    it "has a secondary phone number" do
      expect(org).to respond_to(:secondary_phone)
    end

    it "has a title" do
      expect(org).to respond_to(:title)
    end

    it "has transportation" do
      expect(org).to respond_to(:transportation)
    end

    it "has agreement one" do
      expect(org).to respond_to(:agreement_one)
    end

    it "has agreement two" do
      expect(org).to respond_to(:agreement_two)
    end

    it "has agreement three" do
      expect(org).to respond_to(:agreement_three)
    end

    it "has agreement four" do
      expect(org).to respond_to(:agreement_four)
    end

    it "has agreement five" do
      expect(org).to respond_to(:agreement_five)
    end

    it "has agreement six" do
      expect(org).to respond_to(:agreement_six)
    end

    it "has agreement seven" do
      expect(org).to respond_to(:agreement_seven)
    end

    it "has agreement eight" do
      expect(org).to respond_to(:agreement_eight)
    end

  end

  describe "associations" do

    it "has many users" do
      should have_many(:users)
    end

    it "has many tickets" do
      should have_many(:tickets)
    end

    it "has and belongs to many resource categories" do
      should have_and_belong_to_many(:resource_categories)
    end

  end


  describe "validate length of" do

    it "email" do
      should validate_length_of(:email).
        is_at_least(1).
        is_at_most(255)
    end

    it "name" do
      should validate_length_of(:name).
        is_at_least(1).
        is_at_most(255)
    end

    it "the description" do
      should validate_length_of(:description).
        is_at_most(1020)
    end

  end
end
