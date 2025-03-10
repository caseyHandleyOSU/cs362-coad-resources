require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  context 'as a logged out user' do
    
    it 'visiting users redirects to new session page' do
      get(:all_emails)

      expect(response).to redirect_to(new_user_session_path)
    end

  end

  context 'as a logged in, non-admin, user' do
    before(:each) do
      user = FactoryBot.create(:user)
      sign_in(user)
    end

    it 'visiting users redirects to dashboard' do
      get(:all_emails)

      expect(response).to redirect_to(dashboard_path)
    end

  end

  context 'as an admin user' do
    before(:each) do
      user = FactoryBot.create(:user, :admin)
      sign_in(user)
    end

    it 'visiting users is successful' do
      get(:all_emails)

      expect(response).to be_successful()
    end

  end
  
end
