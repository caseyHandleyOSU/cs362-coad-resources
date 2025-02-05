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
        let(:user) { double('User') }
        let(:organization) { double('Organization') }

        context 'when user is an admin' do
            it 'returns admin_dashboard' do
                allow(user).to receive(:admin?).and_return(true)
                expect(helper.dashboard_for(user)).to eq('admin_dashboard')
            end
        end

        context 'when user has an organization that is submitted' do
            it 'returns organization_submitted_dashboard' do
                allow(user).to receive(:admin?).and_return(false)
                allow(user).to receive(:organization).and_return(organization)
                allow(organization).to receive(:submitted?).and_return(true)

                expect(helper.dashboard_for(user)).to eq('organization_submitted_dashboard')
            end
        end

        context 'when user has an organization that is approved' do
            it 'returns organization_approved_dashboard' do
                allow(user).to receive(:admin?).and_return(false)
                allow(user).to receive(:organization).and_return(organization)
                allow(organization).to receive(:submitted?).and_return(false)
                allow(organization).to receive(:approved?).and_return(true)

                expect(helper.dashboard_for(user)).to eq('organization_approved_dashboard')
            end
        end

        context 'when user has no approved or submitted organization' do
            it 'returns create_application_dashboard' do
                allow(user).to receive(:admin?).and_return(false)
                allow(user).to receive(:organization).and_return(nil)

                expect(helper.dashboard_for(user)).to eq('create_application_dashboard')
            end
        end
    end
end
