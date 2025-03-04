require 'rails_helper'

RSpec.describe Region, type: :model do
  let(:region) { build(:region) }

  describe 'attributes' do
    it 'has a name' do
      should respond_to(:name)
    end
  end

  describe 'methods' do
    it 'to_s' do
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
    it 'has many tickets' do
      should have_many(:tickets)
    end
  end

  describe 'validations' do
    describe 'presence of' do

      it 'name' do
        should validate_presence_of(:name)
      end
    end

    describe 'length of' do
      it 'name' do
        should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create)
      end
    end

    describe 'unqiueness of' do
      it 'name' do
        should validate_uniqueness_of(:name).case_insensitive
      end
    end
  end
end