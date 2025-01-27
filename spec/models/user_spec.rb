require 'rails_helper'

RSpec.describe User, type: :model do 

    let(:user) { User.new }

    describe "attributes" do

        it "responds to email" do
            expect(user).to respond_to(:email)
        end

        it "responds to encrypted_password" do
            expect(user).to respond_to(:encrypted_password)
        end

        it "responds to reset_password_token" do
            expect(user).to respond_to(:reset_password_token)
        end

        it "responds to confirmation_token" do
            expect(user).to respond_to(:confirmation_token)
        end

        it "responds to unconfirmed_email" do
            expect(user).to respond_to(:unconfirmed_email)
        end

        it "responds to role" do
            expect(user).to respond_to(:role)
        end

        it "responds to organization_id" do
            expect(user).to respond_to(:organization_id)
        end
    end

    describe "associations" do

        it "belongs_to organization" do
            expect(User.reflect_on_association(:organization).macro).to eq(:belongs_to)
        end
    end

    describe "methods" do

        it "returns string of email" do
            user.email = "TestEmail@gmail.com"
            expect(user.to_s).to eq("TestEmail@gmail.com")
        end
    end

    describe 'length validations' do
        it 'email' do
            should validate_length_of(:email).is_at_least(1).is_at_most(255).on(:create)
        end

        it 'password' do
            should validate_length_of(:password).is_at_least(7).is_at_most(255).on(:create)
        end
    end

    describe 'unique validations' do
        it 'email' do
            should validate_uniqueness_of(:email).case_insensitive
        end
    end
end
