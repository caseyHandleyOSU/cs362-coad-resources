require 'rails_helper'

RSpec.describe 'Deleting a Ticket', type: :feature do

  before(:each) do
    @ticket = FactoryBot.create(:ticket)
    admin = FactoryBot.create(:user, :admin)
    log_in_as(admin)
  end

  it 'deletes a ticket successfully' do
    visit(dashboard_path)
    
    expect(page).to have_selector('a', text: @ticket.name)
    click_on(@ticket.name)
    click_on('Delete')

    expect(current_path).to eq(dashboard_path)
    expect(page).not_to have_selector('a', text: @ticket.name)
  end

end
