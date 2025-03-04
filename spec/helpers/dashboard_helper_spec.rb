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
    describe 'dashboard_for' do
        let(:user) { create(:user) }
        let(:organization) { create(:organization) }

        shared_examples 'dashboard equals' do
            it { expect(helper.dashboard_for(@user)).to eq(@dash) }
        end

        context 'when user is an admin' do
            before do
                @dash = 'admin_dashboard'
                allow(user).to receive(:admin?).and_return(true)
                @user = user
            end

            it_behaves_like 'dashboard equals'
        end

        context 'when user has an organization that is submitted' do
            before do
                @dash = 'organization_submitted_dashboard'
                allow(user).to receive(:admin?).and_return(false)
                allow(user).to receive(:organization).and_return(organization)
                allow(organization).to receive(:submitted?).and_return(true)
                @user = user 
            end

            it_behaves_like 'dashboard equals'
        end

        context 'when user has an organization that is approved' do
            before do
                @dash = 'organization_approved_dashboard'
                allow(user).to receive(:admin?).and_return(false)
                allow(user).to receive(:organization).and_return(organization)
                allow(organization).to receive(:submitted?).and_return(false)
                allow(organization).to receive(:approved?).and_return(true)
                @user = user
            end
            
            it_behaves_like 'dashboard equals'
        end

        context 'when user has no approved or submitted organization' do
            before do
                @dash = 'create_application_dashboard'
                allow(user).to receive(:admin?).and_return(false)
                allow(user).to receive(:organization).and_return(nil)
                @user = user
            end

            it_behaves_like 'dashboard equals'
        end
    end
end
