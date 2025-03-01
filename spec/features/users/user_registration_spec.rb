require 'rails_helper'

RSpec.describe 'User registration', type: :feature do

  shared_examples 'sign up a user' do

    before(:each) do
      @dummy_usr = FactoryBot.build(:user)
    end

    it do
      visit(root_path)

      click_on('Sign up')
      fill_in('Email', with: @dummy_usr.email)
      fill_in('Password', with: @dummy_usr.password)
      fill_in('Password confirmation', with: @dummy_usr.password)
      
      find('#commit').click
      
      expect(current_path).to eq(@destination)
    end
  end

  context 'with successful captcha' do
    before(:each) { @destination = dashboard_path }

    it_behaves_like 'sign up a user'
  end

  context 'with unsuccessful captcha' do
    before(:each) do
      expect_any_instance_of(Users::RegistrationsController).
        to receive(:verify_recaptcha).
        and_return(false) 

      @destination = user_registration_path
    end

    it_behaves_like 'sign up a user'
  end

end
