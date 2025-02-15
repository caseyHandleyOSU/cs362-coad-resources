require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  shared_examples "dashboard controller tests" do

    describe "as a logged out user" do
      let(:user) { FactoryBot.create(:user) }
      after(:each) { expect(response).not_to be_successful()}

      it "test index" do
        get(
          :index,
          params: params
        )
      end

    end

    describe "as a logged in user" do
      let(:user) { FactoryBot.create(:user) }
      before(:each) { sign_in user }
      after(:each) { expect(response).to be_successful() }

      it "test index" do
        get(
          :index,
          params: params
        )
      end

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
  end
  
end
