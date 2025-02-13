require 'rails_helper'

RSpec.describe TicketsController, type: :controller do

  describe "as a non-organization user" do
    let(:user) { FactoryBot.create(:user) }
    before(:each) { sign_in user }

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
          ticket: FactoryBot.attributes_for(:ticket)
        }
      )

      expect(response).to be_successful()
    end

    it "GET show" do
      ticket = FactoryBot.build_stubbed(:ticket)
      get(
        :show,
        params: {
          id: ticket.id
        }
      )

      expect(response).to redirect_to(dashboard_path)
    end

    it "POST capture" do
      ticket = FactoryBot.build_stubbed(:ticket)
      post(
        :capture,
        params: {
          id: ticket.id
        }
      )

      expect(response).to redirect_to(dashboard_path)
    end

    it "POST release" do
      ticket = FactoryBot.build_stubbed(:ticket)
      post(
        :release,
        params: {
          id: ticket.id
        }
      )

      expect(response).to redirect_to(dashboard_path)
    end

    it "PATCH close" do
      ticket = FactoryBot.build_stubbed(:ticket)
      patch(
        :close,
        params: {
          id: ticket.id
        }
      )

      expect(response).to redirect_to(dashboard_path)
    end
    
  end

  describe "as an organization user" do
    let(:user) {  }
    before(:each) { 
      @org = FactoryBot.create(:organization, :approved)
      user = FactoryBot.create(:user, organization_id: @org.id)
      sign_in user
    }

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
          ticket: FactoryBot.attributes_for(:ticket)
        }
      )

      expect(response).to be_successful()
    end

    it "GET show" do
      ticket = FactoryBot.create(:ticket)
      get(
        :show,
        params: {
          id: ticket.id
        }
      )

      expect(response).to be_successful()
    end

    it "POST capture" do
      ticket = FactoryBot.create(:ticket)
      post(
        :capture,
        params: {
          id: ticket.id
        }
      )

      expect(response).to redirect_to(dashboard_path << "#tickets:open")
    end

    describe "POST release" do

      it "owned ticket" do
        ticket = FactoryBot.create(:ticket, organization_id: @org.id)
        post(
          :release,
          params: {
            id: ticket.id
          }
        )

        expect(response).to redirect_to(dashboard_path << "#tickets:organization")
      end

      it "other's ticket" do
        ticket = FactoryBot.create(:ticket)
        post(
          :release,
          params: {
            id: ticket.id
          }
        )

        expect(response).to be_successful()
      end

    end

    describe "PATCH close" do

      it "owned ticket" do
        ticket = FactoryBot.create(:ticket, organization_id: @org.id)
        patch(
          :close,
          params: {
            id: ticket.id
          }
        )

        expect(response).to redirect_to(dashboard_path << "#tickets:organization")
      end

      it "other's ticket" do
        ticket = FactoryBot.create(:ticket)
        patch(
          :close,
          params: {
            id: ticket.id
          }
        )

        expect(response).to be_successful()
      end

    end
    
  end
end
