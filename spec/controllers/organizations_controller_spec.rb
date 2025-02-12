require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  describe "as a logged out user" do
    after(:each) { 
      expect(response).not_to be_successful
      expect(response).to redirect_to(new_user_session_path)
    }

    it "GET index" do
      get(
        :index
      )
    end

    it "GET new" do
      get(
        :new
      )
    end

    it "POST create" do
      post(
        :create
      )
    end

    it "GET edit" do
      org = FactoryBot.create(:organization)
      get(
        :edit,
        params: {
          id: org.id,
          organization: FactoryBot.attributes_for(:organization)
        }
      )
    end

    it "PATCH update" do
      org = FactoryBot.create(:organization)
      patch(
        :update,
        params: {
          id: org.id
        }
      )
    end

    it "PUT update" do
      org = FactoryBot.create(:organization)
      put(
        :update,
        params: {
          id: org.id
        }
      )
    end

    it "GET show" do
      org = FactoryBot.create(:organization)
      get(
        :show,
        params: {
          id: org.id
        }
      )
    end

    it "POST approve" do
      org = FactoryBot.create(:organization)
      post(
        :approve,
        params: {
          id: org.id
        }
      )
    end

    it "POST reject" do
      org = FactoryBot.create(:organization)
      post(
        :reject,
        params: {
          id: org.id
        }
      )
    end

  end

end
