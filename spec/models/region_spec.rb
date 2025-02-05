require 'rails_helper'

RSpec.describe Region, type: :model do
  let(:region) { build(:region) } # Uses FactoryBot

  describe 'attributes' do
    it { should respond_to(:name) }
  end

  describe 'methods' do
    it { should respond_to(:to_s) }
    
    it 'responds to self.unspecified' do
      expect(Region).to respond_to(:unspecified)
    end

    it 'returns name as string representation' do
      region.name = "Test Region"
      expect(region.to_s).to eq("Test Region")
    end

    it 'creates or finds the "Unspecified" region' do
      region = Region.unspecified
      expect(region).to be_persisted
      expect(region.name).to eq("Unspecified")
    end
  end

  describe 'associations' do
    it { should have_many(:tickets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end