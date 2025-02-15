require 'rails_helper'

RSpec.describe ResourceCategoriesController, type: :controller do

  describe "as a logged out user" do
    let(:user) { FactoryBot.create(:user) }
    after(:each) { 
      expect(response).not_to be_successful() 
      expect(response).to redirect_to(new_user_session_path)
    }

    it "GET index" do
      get(
        :index
      )
    end

    it "GET show" do
      cat = FactoryBot.create(:resource_category)
      get(
        :show,
        params: {
          id: cat.id
        }
      )
    end

    it "GET new" do
      get(
        :new
      )
    end

    it "POST create" do
      post(
        :create,
        params: {
          resource_category: FactoryBot.attributes_for(:resource_category)
        }
      )
    end

    it "GET edit" do
      cat = FactoryBot.create(:resource_category)
      get(
        :edit,
        params: {
          id: cat.id
        }
      )
    end

    it "PUT update" do
      cat = FactoryBot.create(:resource_category)
      put(
        :update,
        params: {
          id: cat.id,
          resource_category: FactoryBot.attributes_for(:resource_category)
        }
      )
    end

    it "PATCH update" do
      cat = FactoryBot.create(:resource_category)
      patch(
        :update,
        params: {
          id: cat.id,
          resource_category: FactoryBot.attributes_for(:resource_category)
        }
      )
    end

    it "PATCH activate" do
      cat = FactoryBot.create(:resource_category)
      patch(
        :activate,
        params: {
          id: cat.id
        }
      )
    end

    it "PATCH deactivate" do
      cat = FactoryBot.create(:resource_category)
      patch(
        :deactivate,
        params: {
          id: cat.id
        }
      )
    end

    it "DELETE destroy" do
      cat = FactoryBot.create(:resource_category)
      delete(
        :destroy,
        params: {
          id: cat.id
        }
      )
    end

  end

  describe "as a logged in user" do
    let(:user) { FactoryBot.create(:user) }
    before(:each) { sign_in user }
    after(:each) { 
      expect(response).not_to be_successful() 
      expect(response).to redirect_to(dashboard_path)
    }

    it "GET index" do
      get(
        :index
      )
    end

    it "GET show" do
      cat = FactoryBot.create(:resource_category)
      get(
        :show,
        params: {
          id: cat.id
        }
      )
    end

    it "GET new" do
      get(
        :new
      )
    end

    it "POST create" do
      post(
        :create,
        params: {
          resource_category: FactoryBot.attributes_for(:resource_category)
        }
      )
    end

    it "GET edit" do
      cat = FactoryBot.create(:resource_category)
      get(
        :edit,
        params: {
          id: cat.id
        }
      )
    end

    it "PUT update" do
      cat = FactoryBot.create(:resource_category)
      put(
        :update,
        params: {
          id: cat.id,
          resource_category: FactoryBot.attributes_for(:resource_category)
        }
      )
    end

    it "PATCH update" do
      cat = FactoryBot.create(:resource_category)
      patch(
        :update,
        params: {
          id: cat.id,
          resource_category: FactoryBot.attributes_for(:resource_category)
        }
      )
    end

    it "PATCH activate" do
      cat = FactoryBot.create(:resource_category)
      patch(
        :activate,
        params: {
          id: cat.id
        }
      )
    end

    it "PATCH deactivate" do
      cat = FactoryBot.create(:resource_category)
      patch(
        :deactivate,
        params: {
          id: cat.id
        }
      )
    end

    it "DELETE destroy" do
      cat = FactoryBot.create(:resource_category)
      delete(
        :destroy,
        params: {
          id: cat.id
        }
      )
    end

  end

  describe "as an admin user" do
    let(:user) { FactoryBot.create(:user, :admin) }
    before(:each) { sign_in user }
    # after(:each) { expect(response).to be_successful() }

    it "GET index" do
      get(
        :index
      )
      expect(response).to be_successful()
    end

    it "GET show" do
      cat = FactoryBot.create(:resource_category)
      get(
        :show,
        params: {
          id: cat.id
        }
      )
      expect(response).to be_successful()
    end

    it "GET new" do
      get(
        :new
      )
      expect(response).to be_successful()
    end

    it "POST create" do
      post(
        :create,
        params: {
          resource_category: FactoryBot.attributes_for(:resource_category)
        }
      )
      expect(response).to redirect_to(resource_categories_path)
    end

    it "GET edit" do
      cat = FactoryBot.create(:resource_category)
      get(
        :edit,
        params: {
          id: cat.id
        }
      )
      expect(response).to be_successful()
    end

    it "PUT update" do
      cat = FactoryBot.create(:resource_category)
      put(
        :update,
        params: {
          id: cat.id,
          resource_category: FactoryBot.attributes_for(:resource_category)
        }
      )
      expect(response).to redirect_to(cat)
    end

    it "PATCH update" do
      cat = FactoryBot.create(:resource_category)
      patch(
        :update,
        params: {
          id: cat.id,
          resource_category: FactoryBot.attributes_for(:resource_category)
        }
      )
      expect(response).to redirect_to(cat)
    end

    it "PATCH activate" do
      cat = FactoryBot.create(:resource_category)
      patch(
        :activate,
        params: {
          id: cat.id
        }
      )
      expect(response).to redirect_to(cat)
    end

    it "PATCH deactivate" do
      cat = FactoryBot.create(:resource_category)
      patch(
        :deactivate,
        params: {
          id: cat.id
        }
      )
      expect(response).to redirect_to(cat)
    end

    it "DELETE destroy" do
      cat = FactoryBot.create(:resource_category)
      delete(
        :destroy,
        params: {
          id: cat.id
        }
      )
      expect(response).to redirect_to(resource_categories_path)
    end

  end

end
