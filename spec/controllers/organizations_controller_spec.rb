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

  describe "as an approved user" do
    before(:each) do 
      org = FactoryBot.create(:organization, :approved)
      @user = FactoryBot.create(:user, organization_id: org.id)
      sign_in @user
    end

    it "GET index" do
      get(
        :index
      )
      expect(response).to be_successful
    end

    it "GET new" do
      get(
        :new
      )
      expect(response).to redirect_to(dashboard_path)
    end

    it "POST create" do
      post(
        :create
      )
      expect(response).to redirect_to(dashboard_path)
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
      expect(response).to be_successful
    end

    describe "PATCH update" do

      it "correctly" do
        org = FactoryBot.create(:organization)
        patch(
          :update,
          params: {
            id: org.id,
            organization: FactoryBot.attributes_for(:organization)
          }
        )
        expect(response).to redirect_to(organization_path(id: org.id))
      end

      it "incorrectly" do
        allow_any_instance_of(Organization).
          to receive(:update).
          and_return(false)
        org = FactoryBot.create(:organization)
        patch(
          :update,
          params: {
            id: org.id,
            organization: FactoryBot.attributes_for(:organization)
          }
        )
        expect(response).not_to redirect_to(dashboard_path)
        expect(response).to be_successful()
      end

    end

    it "PUT update" do
      org = FactoryBot.create(:organization)
      put(
        :update,
        params: {
          id: org.id,
          organization: FactoryBot.attributes_for(:organization)
        }
      )
      expect(response).to redirect_to(organization_path(id: org.id))
    end

    it "GET show" do
      org = FactoryBot.create(:organization)
      get(
        :show,
        params: {
          id: org.id
        }
      )
      expect(response).to be_successful()
    end

    it "POST approve" do
      org = FactoryBot.create(:organization)
      post(
        :approve,
        params: {
          id: org.id
        }
      )
      expect(response).to redirect_to(dashboard_path)
    end

    it "POST reject" do
      org = FactoryBot.create(:organization)
      post(
        :reject,
        params: {
          id: org.id
        }
      )
      expect(response).to redirect_to(dashboard_path)
    end

  end

  describe "as an un-approved user" do
    before(:each) do 
      org = FactoryBot.create(:organization, :unapproved)
      @user = FactoryBot.create(:user)
      sign_in @user
    end

    it "GET index" do
      get(
        :index
      )
      expect(response).to be_successful()
    end

    it "GET new" do
      get(
        :new
      )
      expect(response).to be_successful()
    end

    describe "POST create" do
      
      it "correctly" do 
        # Create admin user to bypass email error
        admin = FactoryBot.create(:user, :admin)
        post(
          :create,
          params: {
            organization: FactoryBot.attributes_for(:organization)
          }
        )
        expect(response).to redirect_to(organization_application_submitted_path)
      end

      it "incorrectly" do
        post(
          :create,
          params: {
            organization: { email: nil }
          }
        )
        expect(response).not_to redirect_to(organization_application_submitted_path)
        expect(response).to be_successful()
      end

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
      expect(response).to redirect_to(dashboard_path)
    end

    describe "PATCH update" do

      it "correctly" do
        org = FactoryBot.create(:organization)
        patch(
          :update,
          params: {
            id: org.id,
            organization: FactoryBot.attributes_for(:organization)
          }
        )
        expect(response).to redirect_to(dashboard_path)
      end

    end

    it "PUT update" do
      org = FactoryBot.create(:organization)
      put(
        :update,
        params: {
          id: org.id,
          organization: FactoryBot.attributes_for(:organization)
        }
      )
      expect(response).to redirect_to(dashboard_path)
    end

    it "GET show" do
      org = FactoryBot.create(:organization)
      get(
        :show,
        params: {
          id: org.id
        }
      )
      expect(response).not_to be_successful()
    end

    it "POST approve" do
      org = FactoryBot.create(:organization)
      post(
        :approve,
        params: {
          id: org.id
        }
      )
      expect(response).to redirect_to(dashboard_path)
    end

    it "POST reject" do
      org = FactoryBot.create(:organization)
      post(
        :reject,
        params: {
          id: org.id
        }
      )
      expect(response).to redirect_to(dashboard_path)
    end

  end

  describe "as an admin user" do
    before(:each) do 
      @user = FactoryBot.create(:user, :admin)
      sign_in @user
    end

    it "GET index" do
      get(
        :index
      )
      expect(response).to be_successful()
    end

    it "GET new" do
      get(
        :new
      )
      expect(response).not_to be_successful()
    end

    it "POST create" do
      admin = FactoryBot.create(:user, :admin)
      post(
        :create,
        params: {
          organization: FactoryBot.attributes_for(:organization)
        }
      )
      expect(response).not_to be_successful()
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
      expect(response).to redirect_to(dashboard_path)
    end

    it "PATCH update" do
      org = FactoryBot.create(:organization)
      patch(
        :update,
        params: {
          id: org.id,
          organization: FactoryBot.attributes_for(:organization)
        }
      )
      expect(response).to redirect_to(dashboard_path)
    end

    it "PUT update" do
      org = FactoryBot.create(:organization)
      put(
        :update,
        params: {
          id: org.id,
          organization: FactoryBot.attributes_for(:organization)
        }
      )
      expect(response).to redirect_to(dashboard_path)
    end

    it "GET show" do
      org = FactoryBot.create(:organization)
      get(
        :show,
        params: {
          id: org.id
        }
      )
      expect(response).to be_successful()
    end

    describe "POST approve" do

      it "a valid organization" do
        org = FactoryBot.create(:organization, :unapproved)
        post(
          :approve,
          params: {
            id: org.id
          }
        )
        expect(response).to redirect_to(organizations_path)
      end

      it "an invalid organization" do
        org = FactoryBot.create(:organization, :unapproved)

        expect_any_instance_of(Organization).
          to receive(:save).
          and_return(false)

        post(
          :approve,
          params: {
            id: org.id
          }
        )
        expect(response).to redirect_to(organization_path(id: org.id))
      end

    end

    describe "POST reject" do

      it "with a valid organization" do
        org = FactoryBot.create(:organization, :unapproved)
        post(
          :reject,
          params: {
            id: org.id,
            organization: {
              rejection_reason: "Testing"
            }
          }
        )
        expect(response).to redirect_to(organizations_path)
      end

      it "with an invalid organization" do
        org = FactoryBot.create(:organization, :unapproved)

        expect_any_instance_of(Organization).
          to receive(:save).
          and_return(false)

        post(
          :reject,
          params: {
            id: org.id,
            organization: {
              rejection_reason: "Testing"
            }
          }
        )
        expect(response).to redirect_to(organization_path(id: org.id))
      end

    end

  end

end
