require 'rails_helper'

RSpec.describe Region, type: :model do

  let(:region) {Region.new}

  describe 'attributes' do
    
    it "responds to name" do
      expect(region).to respond_to(:name)
    end
  end

  describe 'methods' do
    
    it 'responds to to_s' do
      expect(region).to respond_to(:to_s)
    end

    it 'responds to self.unspecified' do
      expect(Region).to respond_to(:unspecified)
    end
  end

  describe 'associations' do
    
    it 'has many tickets' do
      expect(Region.reflect_on_association(:tickets).macro).to eq(:has_many)
    end
  end

  describe 'length validations' do
    it 'name' do
      should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create)
    end
  end

  describe 'unique validations' do
    it 'name' do
      should validate_uniqueness_of(:name).case_insensitive
    end
  end
end