require 'rails_helper'

RSpec.describe 'User registration', type: :feature do

  before(:each) do
    @dummy_usr = FactoryBot.build(:user)
  end

  it 'signs up a user successfully' do
    visit(root_path)

    click_on('Sign up')
    fill_in('Email', with: @dummy_usr.email)
    fill_in('Password', with: @dummy_usr.password)
    fill_in('Password confirmation', with: @dummy_usr.password)
    
    find('#commit').click
    
    expect(current_path).to eq(dashboard_path)
  end

end
