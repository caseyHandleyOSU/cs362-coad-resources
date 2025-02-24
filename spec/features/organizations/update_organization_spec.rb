require 'rails_helper'

RSpec.describe 'Updating an Organization', type: :feature do

  before(:each) do
    @organization = FactoryBot.create(:organization, :approved)
    @user = FactoryBot.create(:user, organization_id: @organization.id)
    log_in_as(@user)
  end

  it 'successfully approves an organization' do
    visit(dashboard_path)

    click_on('Edit Organization')
    fill_in('Name', with: 'My New Name')
    expect(current_path).to eq(edit_organization_path(@organization.id))
    click_on('Update Resource')

    expect(current_path).to eq(organization_path(@organization.id))
  end

end
