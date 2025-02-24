require 'rails_helper'

RSpec.describe 'Logging in', type: :feature do

  it 'logs in an existing user successfully' do
    user = FactoryBot.create(:user)
    log_in_as(user)

    expect(current_path).to eq(dashboard_path)
  end

  it 'does not log in an invalid user' do
    user = FactoryBot.build(:user)
    log_in_as(user)

    expect(current_path).to eq(new_user_session_path)
  end

end
