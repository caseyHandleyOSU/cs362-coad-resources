require 'rails_helper'

RSpec.describe 'Creating a Region', type: :feature do

  before(:each) do
    user = FactoryBot.create(:user, :admin)
    log_in_as(user)
  end

  it 'creates a new region' do
    visit(new_region_path)

    fill_in('Name', with: 'My Cool Region!')
    click_on('Add Region')

    expect(current_path).to eq(regions_path)
  end

end
