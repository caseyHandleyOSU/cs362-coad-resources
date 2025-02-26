require 'rails_helper'

RSpec.describe 'Capturing a ticket', type: :feature do

  before(:each) do
    @org = FactoryBot.create(:organization, :approved)
    @ticket = FactoryBot.create(:ticket)
    @user = FactoryBot.create(:user, organization_id: @org.id)
    log_in_as(@user)
  end

  it 'captures a ticket as a user with an organization' do
    visit(dashboard_path)

    click_on('Tickets')
    expect(page).to have_selector('a', text: @ticket.name)
    click_on(@ticket.name)
    expect(current_path).to eq(ticket_path(@ticket))
    click_on('Capture')
    
    expect(current_path).to eq(dashboard_path)
  end

end
