require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:organization) { build(:organization) }

  describe "attributes" do
    it "responds to agreement attributes" do
        expect(organization).to respond_to(:agreement_one, :agreement_two, :agreement_three,
                                            :agreement_four, :agreement_five, :agreement_six,
                                            :agreement_seven, :agreement_eight)
    end

    it 'has a name' do
      expect(organization).to respond_to(:name)
    end

    it 'has a status' do
      expect(organization).to respond_to(:status)
    end

    it 'has a phone number' do
      expect(organization).to respond_to(:phone)
    end

    it 'has an email' do
      expect(organization).to respond_to(:email)
    end

    it 'has a description' do
      expect(organization).to respond_to(:description)
    end

    it 'has a rejection reason' do
      expect(organization).to respond_to(:rejection_reason)
    end

    it 'has liability insurance' do
      expect(organization).to respond_to(:liability_insurance)
    end

    it "has a primary contact name" do
      expect(organization).to respond_to(:primary_name)
    end

    it "has a secondary contact name" do
      expect(organization).to respond_to(:secondary_name)
    end

    it "has a secondary phone number" do
      expect(organization).to respond_to(:secondary_phone)
    end

    it "has a title" do
      expect(organization).to respond_to(:title)
    end

    it "has transportation" do
      expect(organization).to respond_to(:transportation)
    end
  end

  describe 'associations' do
    it 'has many users' do 
      should have_many(:users)
    end

    it 'has many tickets' do
      should have_many(:tickets)
    end

    it 'has and belongs to many resource categories' do 
      should have_and_belong_to_many(:resource_categories)
    end
  end

  describe 'methods' do
    it "sets status to :approved" do
      organization.approve
      expect(organization.status).to eq('approved')
    end

    it "sets status to :rejected" do
      organization.reject
      expect(organization.status).to eq('rejected')
    end

    describe 'set_default_status' do
      it "sets default status to :submitted for new records" do
        new_org = build(:organization, status: nil)
        new_org.set_default_status
        expect(new_org.status).to eq('submitted')
      end

      it "does not overwrite existing status" do
        org = build(:organization, status: :approved)
        org.set_default_status
        expect(org.status).to eq('approved')
      end
    end

    it "to_s" do 
      organization.update(name: "Test Org")
      expect(organization.to_s).to eq("Test Org")
    end
  end

  describe 'validations' do
    describe 'validate presence of' do

      it 'email' do 
        should validate_presence_of(:email)
      end

      it 'phone' do 
        should validate_presence_of(:phone)
      end

      it 'status' do 
        should validate_presence_of(:status)
      end
      
      it 'primary name' do 
        should validate_presence_of(:primary_name)
      end

      it 'secondary name' do
        should validate_presence_of(:secondary_name)
      end

      it 'secondary phone' do 
        should validate_presence_of(:secondary_phone)
      end
    end

    describe 'validate length of' do

      it 'email' do 
        should validate_length_of(:email).is_at_least(1).is_at_most(255).on(:create)
      end

      it 'name' do
        should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create)
      end

      it 'description' do
        should validate_length_of(:description).is_at_most(1020).on(:create)
      end
    end

    describe 'validate uniqueness of' do

      it 'email' do
        should validate_uniqueness_of(:email).case_insensitive
      end

      it 'name' do
        should validate_uniqueness_of(:name).case_insensitive
      end
    end

    describe 'email format' do
      it { should allow_value("someemail@email.com").for(:email) }
      it { should_not allow_value("bobby").for(:email) }
      it { should_not allow_value("bobby@email").for(:email) }
      it { should_not allow_value("bobby@email.th3").for(:email) }
    end
  end
end
