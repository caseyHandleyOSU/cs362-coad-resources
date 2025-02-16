require 'rails_helper'

RSpec.describe RegionsController, type: :controller do

  describe "as a logged out user" do 
    let(:user) { FactoryBot.create(:user) }
    after(:each) { 
      expect(response).not_to be_successful() 
      expect(response).to redirect_to(new_user_session_path)
    }

    it "test index" do
      get(
        :index
      )
    end

    it "test create" do
      get(
        :index
      )
    end

    it "test new" do
      region = FactoryBot.create(:region)
      get(
        :new,
        params: {
          id: region.id
        }
      )
    end

    it "test edit" do
      region = FactoryBot.create(:region)
      get(
        :edit,
        params: {
          id: region.id
        }
      )
    end

    it "test show" do
      region = FactoryBot.create(:region)
      get(
        :show,
        params: {
          id: region.id
        }
      )
    end

    it "test PUT update" do
      region = FactoryBot.create(:region)
      put(
        :update,
        params: {
          id: region.id,
          region: FactoryBot.attributes_for(:region)
        }
      )
    end

    it "test PATCH update" do
      region = FactoryBot.create(:region)
      patch(
        :update,
        params: {
          id: region.id,
          region: FactoryBot.attributes_for(:region)
        }
      )
    end

    it "test destroy" do
      region = FactoryBot.create(:region)
      delete(
        :destroy,
        params: {
          id: region.id,
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

    it "test index" do
      get(
        :index
      )
    end

    it "test create" do
      get(
        :index
      )
    end

    it "test new" do
      region = FactoryBot.create(:region)
      get(
        :new,
        params: {
          id: region.id
        }
      )
    end

    it "test edit" do
      region = FactoryBot.create(:region)
      get(
        :edit,
        params: {
          id: region.id
        }
      )
    end

    it "test show" do
      region = FactoryBot.create(:region)
      get(
        :show,
        params: {
          id: region.id
        }
      )
    end

    it "test PUT update" do
      region = FactoryBot.create(:region)
      put(
        :update,
        params: {
          id: region.id,
          region: FactoryBot.attributes_for(:region)
        }
      )
    end

    it "test PATCH update" do
      region = FactoryBot.create(:region)
      patch(
        :update,
        params: {
          id: region.id,
          region: FactoryBot.attributes_for(:region)
        }
      )
    end

    it "test destroy" do
      region = FactoryBot.create(:region)
      delete(
        :destroy,
        params: {
          id: region.id,
        }
      )
    end

  end

  describe "as an admin user" do
    let(:user) { FactoryBot.create(:user, :admin) }
    before(:each) { sign_in user }

    it "test index" do
      expect(get(:index)).to be_successful
    end

    it "test creating" do
      post(
        :create,
        params: { 
            region: FactoryBot.attributes_for(:region)
          }
      )

      expect(response).to redirect_to(regions_path)
    end

    it "test new" do
      region = FactoryBot.create(:region)
      get(
        :new,
        params: {
          id: region.id
        }
      )
      
      expect(response).to be_successful()
    end

    it "test edit" do
      region = FactoryBot.create(:region)
      get(
        :edit,
        params: {
          id: region.id
        }
      )

      expect(response).to be_successful()
    end

    it "test show" do
      region = FactoryBot.create(:region)
      get(
        :show,
        params: {
          id: region.id
        }
      )

      expect(response).to be_successful()
    end

    it "test PUT update" do
      region = FactoryBot.create(:region)
      put(
        :update,
        params: {
          id: region.id,
          region: FactoryBot.attributes_for(:region)
        }
      )

      expect(response).to redirect_to(region)

    end

    it "test PATCH update" do
      region = FactoryBot.create(:region)
      patch(
        :update,
        params: {
          id: region.id,
          region: FactoryBot.attributes_for(:region)
        }
      )

      expect(response).to redirect_to(region)

    end

    it "test destroy" do
      region = FactoryBot.create(:region)
      delete(
        :destroy,
        params: {
          id: region.id
        }
      )

      expect(response).to redirect_to(regions_path)
    end

  end

end
