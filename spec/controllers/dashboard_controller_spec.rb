require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  shared_examples "GET index" do
    it do
      get(
        :index,
        params: params
      )
    end
  end

  shared_examples "dashboard controller tests" do

    describe "as a logged out user" do
      let(:user) { FactoryBot.create(:user) }
      after(:each) { expect(response).not_to be_successful()}

      it_behaves_like "GET index"

    end

    describe "as a logged in user" do
      let(:user) { FactoryBot.create(:user) }
      before(:each) { sign_in user }
      after(:each) { expect(response).to be_successful() }

      it_behaves_like "GET index"

    end

    describe "as a logged in organization user" do
      before(:each) {
        org = FactoryBot.create(:organization, :approved)
        user = FactoryBot.create(:user, organization_id: org)
        sign_in user 
      }
      after(:each) { expect(response).to be_successful() }

      it_behaves_like "GET index"

    end

    describe "as an admin user" do
      let(:user) { FactoryBot.create(:user, :admin) }
      before(:each) { sign_in user }
      after(:each) { expect(response).to be_successful() }

      it "test index" do
        get(
          :index,
          params: params
        )
      end

    end

  end

  describe "Open status" do
    let(:params) { {status: 'Open'} }

    it_behaves_like "dashboard controller tests"

  end

  describe "Closed status" do
    let(:params) { {status: 'Closed'} }
    
    it_behaves_like "dashboard controller tests"

  end

  describe "Captured status" do
    let(:params) { {status: 'Captured'} }
    
    it_behaves_like "dashboard controller tests"

  end

  describe "My Captured status" do
    let(:params) { {status: 'My Captured'} }
    
    it_behaves_like "dashboard controller tests"

  end

  describe "My Closed status" do
    let(:params) { {status: 'My Closed'} }
    
    it_behaves_like "dashboard controller tests"

  end

  describe "no status" do
    let(:params) { {status: ''} }
    
    it_behaves_like "dashboard controller tests"

  end
  
end
