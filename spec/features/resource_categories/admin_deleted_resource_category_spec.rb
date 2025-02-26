require 'rails_helper'

RSpec.describe 'Deleting a Resource Category', type: :feature do

  before(:each) do
    admin = FactoryBot.create(:user, :admin)
    log_in_as(admin)
    @resource = FactoryBot.create(:resource_category)
  end

  it 'admin deletes a resource category' do
    visit(resource_category_path(@resource))
    
    click_on("Delete")

    expect(current_path).to eq(resource_categories_path)
    expect(body).not_to have_selector("h3", text: @resource.name)
  end

end
