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
    describe "dashboard_for" do
        let(:admin_user) { double("User", admin?: true, organization: nil) }
        let(:submitted_user) { double("User", admin?: false, organization: double("Organization", submitted?: true, approved?: false)) }
        let(:approved_user) { double("User", admin?: false, organization: double("Organization", submitted?: false, approved?: true)) }
        let(:new_user) { double("User", admin?: false, organization: nil) }

        it "returns 'admin_dashboard' for an admin user" do
            expect(helper.dashboard_for(admin_user)).to eq('admin_dashboard')
        end

        it "returns 'organization_submitted_dashboard' for a user with a submitted organization" do
            expect(helper.dashboard_for(submitted_user)).to eq('organization_submitted_dashboard')
        end

        it "returns 'organization_approved_dashboard' for a user with an approved organization" do
            expect(helper.dashboard_for(approved_user)).to eq('organization_approved_dashboard')
        end

        it "returns 'create_application_dashboard' for a user without an organization" do
            expect(helper.dashboard_for(new_user)).to eq('create_application_dashboard')
        end
    end

end
