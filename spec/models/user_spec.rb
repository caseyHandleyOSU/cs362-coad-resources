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
end
