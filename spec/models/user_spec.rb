require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new }

  describe "attributes" do

    it "has an email" do
      expect(user).to respond_to(:email)
    end

    it "has a role" do
      expect(user).to respond_to(:role)
    end

  end

  describe "associations" do

    it "optionally belongs to an organization" do
      should belong_to(:organization).optional
    end

  end

  describe "validate presence of" do
    
    it "email" do 
      should validate_presence_of(:email)
    end

    it "password" do 
      should validate_presence_of(:password).
        on(:create)
    end

  end

  describe "validate length of" do

    it "email" do
      should validate_length_of(:email).
        is_at_least(1).
        is_at_most(255).
        on(:create)
    end

    it "password" do
      should validate_length_of(:password).
        is_at_least(7).
        is_at_most(255).
        on(:create)
    end

  end

  describe "validate uniqueness of" do

    it "email" do
      should validate_uniqueness_of(:email).
        case_insensitive()
    end

  end

  describe "validate pattern of" do

    describe "email" do

      it "valid" do
        should allow_value("handlcas@oregonstate.edu").for(:email)
      end

      it "invalid" do
        # No Domain
        should_not allow_value("example").for(:email)
        # No TLD
        should_not allow_value("example@example").for(:email)
        # No Domain
        should_not allow_value("example@.com").for(:email)
        # Invalid TLD
        should_not allow_value("example@example.c0m").for(:email)
      end

    end

  end

end
