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

  let(:admin_usr) { 
    User.create!(
      email: "email@email.com", password: "1234567", role: :admin
    )
  }

  let(:user) {
    User.create!(
      email: "email3@email.com", password: "1234567",
    )
  }

  let(:sub_org_usr) { 
    org = Organization.create!(
      name: "myOrg1", email: "e@e.com", description: "", phone: "+15551234567",
      primary_name: "1", secondary_name: "1", secondary_phone: "+15551234567"
    )

    User.create(
      email: "email@email.com", password: "1234567", role: :organization,
      organization: org
    )
  }

  let(:app_org_usr) { 
    org = Organization.create!(
      name: "myOrg2", email: "e2@e.com", description: "", phone: "+15551234567",
      primary_name: "1", secondary_name: "1", secondary_phone: "+15551234567",
      status: :approved
    )

    User.create!(
      email: "email2@email.com", password: "1234567", role: :organization,
      organization: org
    )
  }

  describe "tests dashboard helper" do

    it "dashboard for" do

      expect(helper.dashboard_for(admin_usr)).to eq("admin_dashboard")
      expect(helper.dashboard_for(sub_org_usr)).to eq("organization_submitted_dashboard")
      expect(helper.dashboard_for(app_org_usr)).to eq("organization_approved_dashboard")
      expect(helper.dashboard_for(user)).to eq("create_application_dashboard")

    end

  end

end
