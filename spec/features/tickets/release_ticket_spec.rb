require 'rails_helper'

RSpec.describe 'Releasing a ticket by an', type: :feature do

  before(:each) do
    @org = FactoryBot.create(:organization, :approved)
    @ticket = FactoryBot.create(:ticket, organization_id: @org.id)
    @user = FactoryBot.create(:user, organization_id: @org.id)
    log_in_as(@user)
  end

  it 'releases a ticket as a user with an organization' do
    visit(dashboard_path)

    click_on('Tickets')
    expect(page).to have_selector('a', text: @ticket.name)
    click_on(@ticket.name)
    expect(current_path).to eq(ticket_path(@ticket))
    click_on('Release')
    
    expect(current_path).to eq(dashboard_path)
  end

end
