require 'rails_helper'

RSpec.describe 'Rejecting an organization', type: :feature do

  before(:each) do
    @organization = FactoryBot.create(:organization, :unapproved)
    @user = FactoryBot.create(:user, :admin)
    log_in_as(@user)
  end

  it 'successfully approves an organization' do
    visit(organizations_path)

    click_on(@organization.name)
    expect(current_path).to eq(organization_path(@organization.id))
    click_on('Reject')

    expect(current_path).to eq(organizations_path)
  end

end
