require 'rails_helper'

RSpec.describe 'Retrieving a list of user emails', type: :feature do

  it 'as an admin user visit users' do
    admin = FactoryBot.create(:user, :admin)
    user2 = FactoryBot.create(:user)
    log_in_as(admin)

    visit(users_path)

    expect(page).to have_selector('p', text: @admin.email)
    expect(page).to have_selector('p', text: @user2.email)
  end

end
