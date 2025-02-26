require 'rails_helper'

RSpec.describe 'Creating a Resource Category', type: :feature do
  
  before(:each) do
    admin = FactoryBot.create(:user, :admin)
    log_in_as(admin)
  end

  it 'admin creates a resource category' do
    categoryName = 'My Category'
    visit(resource_categories_path)
    
    click_on("Add Resource Category")   
    expect(current_path).to eq(new_resource_category_path)
    fill_in('Name', with: categoryName)
    click_on('Add resource category')

    expect(current_path).to eq(resource_categories_path)
  end

end
