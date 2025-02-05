require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:organization) { build(:organization) } # Uses FactoryBot

  describe "attributes" do
    it "responds to agreement attributes" do
        expect(organization).to respond_to(:agreement_one, :agreement_two, :agreement_three,
                                            :agreement_four, :agreement_five, :agreement_six,
                                            :agreement_seven, :agreement_eight)
        end
  end

  describe 'associations' do
    it { should have_many(:users) }
    it { should have_many(:tickets) }
    it { should have_and_belong_to_many(:resource_categories) }
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

    it "returns the name of the organization" do 
      organization.name = "Test Org"
      expect(organization.to_s).to eq("Test Org")
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:primary_name) }
    it { should validate_presence_of(:secondary_name) }
    it { should validate_presence_of(:secondary_phone) }

    it { should validate_length_of(:email).is_at_least(1).is_at_most(255).on(:create) }
    it { should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create) }
    it { should validate_length_of(:description).is_at_most(1020).on(:create) }

    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:name).case_insensitive }

    describe 'email format' do
      it { should allow_value("someemail@email.com").for(:email) }
      it { should_not allow_value("bobby").for(:email) }
      it { should_not allow_value("bobby@email").for(:email) }
      it { should_not allow_value("bobby@email.th3").for(:email) }
    end
  end
end
