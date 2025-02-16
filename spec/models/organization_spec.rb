require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:org) { FactoryBot.build_stubbed(:organization) }


  describe "attributes" do

    it "has a name" do
      # org = FactoryBot.build(:organization)
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

  describe "validate presense of" do
    
    it "email" do
      should validate_presence_of(:email)
    end

    it "name" do
      should validate_presence_of(:name)
    end

    it "phone" do
      should validate_presence_of(:phone)
    end

    it "status" do
      should validate_presence_of(:status)
    end

    it "primary name" do
      should validate_presence_of(:primary_name)
    end

    it "secondary name" do
      should validate_presence_of(:secondary_name)
    end

    it "secondary phone" do
      should validate_presence_of(:secondary_phone)
    end

  end

  describe "validate length of" do

    it "email" do
      should validate_length_of(:email).
        is_at_least(1).
        is_at_most(255).
        on(:create)
    end

    it "name" do
      should validate_length_of(:name).
        is_at_least(1).
        is_at_most(255).
        on(:create)
    end

    it "the description" do
      should validate_length_of(:description).
        is_at_most(1020).
        on(:create)
    end

  end

  describe "validate uniqueness of" do
    
    it "email" do
      should validate_uniqueness_of(:email).case_insensitive
    end

    it "name" do
      should validate_uniqueness_of(:name).case_insensitive
    end
    
  end

  describe "validate pattern of" do

    describe "email" do

      it "valid" do
        should allow_value("handlcas@oregonstate.edu").for(:email)
        should allow_value("example@example.com").for(:email)
      end

      it "invalid" do
        # Test without any domain
        should_not allow_value("a").for(:email)
        # Test without TLD
        should_not allow_value("hello@osu").for(:email)
        # Test with invalid TLD
        should_not allow_value("badTld@osu.1234").for(:email)
      end

    end
    

  end

  describe "test static method" do

    it "approve" do
      org = FactoryBot.build_stubbed(:organization)
      org.approve
      expect(org.status).to eq("approved")
    end

    it "reject" do
      org = FactoryBot.build_stubbed(:organization)
      org.reject
      expect(org.status).to eq("rejected")
    end

    it "default status" do
      org = FactoryBot.build_stubbed(:organization)
      expect(org.status).to eq("submitted")
    end

    it "to_s" do
      name = "myOrg1"
      org = FactoryBot.build_stubbed(:organization, name: name)
      expect(org.to_s).to eq(name)
    end

  end

end
