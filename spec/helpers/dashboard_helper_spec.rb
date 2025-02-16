require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the DashboardHelper. For example:
#
# describe DashboardHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe DashboardHelper, type: :helper do

  shared_examples "dashboard equals" do
     it { expect(helper.dashboard_for(@user)).to eq(@dash) }
  end

  describe "tests dashboard for" do

    describe "admin user" do
      before do
        @user = FactoryBot.create(:user, :admin)
        @dash = "admin_dashboard"
      end
      
      it_behaves_like "dashboard equals"
      
    end

    describe "submitted organization user" do
      before do
        org = FactoryBot.create(:organization, :unapproved)
        @user = FactoryBot.create(:user, organization_id: org.id)
        @dash = "organization_submitted_dashboard"
      end

      it_behaves_like "dashboard equals"

    end

    describe "approved organization user" do
      before do
        org = FactoryBot.create(:organization, :approved)
        @user = FactoryBot.create(:user, organization_id: org.id)
        @dash = "organization_approved_dashboard"
      end
      
      it_behaves_like "dashboard equals"
    end

    describe "admin" do
      before do
        @user = FactoryBot.create(:user)
        @dash = "create_application_dashboard"
      end
      
      it_behaves_like "dashboard equals"
    end

  end

end
