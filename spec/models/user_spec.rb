require 'rails_helper'

RSpec.describe User, type: :model do 
  let(:user) { build(:user) }

  describe "attributes" do
    it 'has an email' do
      should respond_to(:email)
    end

    it 'has an encrypted password' do
      should respond_to(:encrypted_password)
    end

    it 'has a reset password token' do
      should respond_to(:reset_password_token)
    end

    it 'has a confirmation token' do
      should respond_to(:confirmation_token)
    end

    it 'has an unconfirmed email' do 
      should respond_to(:unconfirmed_email)
    end

    it 'has a role' do
      should respond_to(:role)
    end

    it 'has an orgnaization_id' do
      should respond_to(:organization_id)
    end
  end

  describe "associations" do
    it 'optionally belogs to an organization' do
      should belong_to(:organization).optional
    end
  end

  describe "methods" do
    it "to_s" do
      user.email = "TestEmail@gmail.com"
      expect(user.to_s).to eq("TestEmail@gmail.com")
    end
  end

  describe "validations" do
    describe 'validate presence of' do
      it 'email' do
        should validate_presence_of(:email)
      end
    end

    describe 'validate length of' do
      it 'email' do
        should validate_length_of(:email).is_at_least(1).is_at_most(255).on(:create)
      end

      it 'password' do
        should validate_length_of(:password).is_at_least(7).is_at_most(255).on(:create)
      end
    end

    describe 'validate uniqueness of' do
      it 'email' do
        should validate_uniqueness_of(:email).case_insensitive
      end
    end
  end

  describe "role management" do
    it "defaults to organization role" do
      expect(user.role).to eq("organization")
    end

    it "can be an admin" do
      admin_user = build(:user, :admin)
      expect(admin_user.role).to eq("admin")
    end
  end
end
