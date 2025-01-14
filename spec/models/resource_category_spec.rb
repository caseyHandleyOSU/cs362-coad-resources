require 'rails_helper'

RSpec.describe ResourceCategory, type: :model do

  it "resource category exists" do
    ResourceCategory.new
  end

  it "has and belongs to many organizations" do
    should have_and_belong_to_many(:organizations)
  end

  it "should have many tickets" do
    should have_many(:tickets)
  end

end
