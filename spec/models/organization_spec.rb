require 'rails_helper'

RSpec.describe Organization, type: :model do

    # REUSABLE INSTANCE VARIABLE
    let(:org) {Organization.new}


    describe "attributes" do

        it "responds to agreement_one" do
            expect(org).to respond_to(:agreement_one)
        end

        it "responds to agreement_two" do
            expect(org).to respond_to(:agreement_two)
        end

        it "responds to agreement_three" do
            expect(org).to respond_to(:agreement_three)
        end

        it "responds to agreement_four" do
            expect(org).to respond_to(:agreement_four)
        end

        it "responds to agreement_five" do
            expect(org).to respond_to(:agreement_five)
        end

        it "responds to agreement_six" do
            expect(org).to respond_to(:agreement_six)
        end

        it "responds to agreement_seven" do
            expect(org).to respond_to(:agreement_seven)
        end

        it "responds to agreement_eight" do
            expect(org).to respond_to(:agreement_eight)
        end

        it "responds to email" do
            expect(org).to respond_to(:email)
        end

        it "responds to name" do
            expect(org).to respond_to(:name)
        end

        it "responds to phone" do
            expect(org).to respond_to(:phone)
        end

        it "responds to status" do
            expect(org).to respond_to(:status)
        end

        it "responds to primary_name" do
            expect(org).to respond_to(:primary_name)
        end

        it "responds to secondary_name" do
            expect(org).to respond_to(:secondary_name)
        end

        it "responds to secondary_phone" do
            expect(org).to respond_to(:secondary_phone)
        end

        it "responds to description" do
            expect(org).to respond_to(:description)
        end

        it "responds to transportation" do
            expect(org).to respond_to(:transportation)
        end

        it "responds to rejection_reason" do
            expect(org).to respond_to(:rejection_reason)
        end

        it "responds to title" do
            expect(org).to respond_to(:title)
        end

        it "responds to liability_insurance" do
            expect(org).to respond_to(:liability_insurance)
        end
    end

    describe 'associations' do

        it "has many users" do
            expect(Organization.reflect_on_association(:users).macro).to eq(:has_many)
        end

        it "has_many tickets" do
            expect(Organization.reflect_on_association(:tickets).macro).to eq(:has_many)
        end

        it "has_and_belongs_to_many resource categories" do
            expect(Organization.reflect_on_association(:resource_categories).macro).to eq(:has_and_belongs_to_many)
        end
    end

    describe 'methods' do

        it "sets status to :approved" do
            org.approve
            expect(org.status).to eq('approved')
        end

        it "sets status to :rejected" do
            org.reject
            expect(org.status).to eq('rejected')
        end

        it "sets default status to :submitted for new records" do
            org.set_default_status
            expect(org.status).to eq('submitted')
        end

        it "does not overwrite existing status" do
            org.status = :approved
            org.set_default_status
            expect(org.status).to eq('approved')
        end

        it "returns the name of the organization" do 
            org.name = "Test Org"
            expect(org.to_s).to eq("Test Org")
        end
    end

    describe 'presence validations' do
        it "email" do
            should validate_presence_of(:email)
        end

        it "phone" do
            should validate_presence_of(:phone)
        end 

        it "status" do
            should validate_presence_of(:status)
        end

        it "primary_name" do
            should validate_presence_of(:primary_name)
        end

        it "secondary_name" do
            should validate_presence_of(:secondary_name)
        end

        it "secondary_phone" do
            should validate_presence_of(:secondary_phone)
        end
    end

    describe 'length validations' do
        it "email" do
            should validate_length_of(:email).is_at_least(1).is_at_most(255).on(:create)
        end

        it "name" do
            should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create)
        end

        it "description" do
            should validate_length_of(:description).is_at_most(1020).on(:create)
        end
    end

    describe "unique validations" do
        it "email" do
            should validate_uniqueness_of(:email).case_insensitive
        end

        it "name" do
            should validate_uniqueness_of(:name).case_insensitive
        end
    end

    describe 'pattern validations' do
        describe 'email' do

            it 'is valid' do
                should allow_value("someemail@email.com").for(:email)
            end

            it 'is not valid' do
                should_not allow_value("bobby").for(:email)
                should_not allow_value("bobby@email").for(:email)
                should_not allow_value("bobby@email.th3").for(:email)
            end
        end
    end

end
