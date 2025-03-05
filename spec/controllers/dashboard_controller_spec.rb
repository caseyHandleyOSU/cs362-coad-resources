require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
    let!(:user) { create(:user) }

    shared_examples 'dashboard controller tests' do

        describe 'logged out user' do
            after(:each) { expect(response).not_to be_successful() }

            it 'index' do
                get :index, params: params
            end
        end

        describe 'logged in user' do
            before(:each) { sign_in user }
            after(:each) { expect(response).to be_successful() }

            it 'index' do
                get :index, params: params
            end
        end

        describe 'logged in organization user' do
            before(:each) { 
                org = create(:organization, :approved)
                org_user = create(:user, organization_id: org.id)
                sign_in org_user 
            }
            after(:each) { expect(response).to be_successful() }

            it 'index' do
                get :index, params: params
            end
        end

        describe 'admin user' do
            before(:each) {
                admin = create(:user, :admin)
                sign_in admin 
            }
            after(:each) { expect(response).to be_successful() }

            it 'index' do
                get :index, params: params
            end
        end
    end

    describe 'status options' do
        describe 'open status' do
            let(:params) { {status: 'Open'} }

            it_behaves_like 'dashboard controller tests'
        end

        describe 'closed status' do
            let(:params) { {status: 'Closed'} }

            it_behaves_like 'dashboard controller tests'
        end

        describe 'captured status' do
            let(:params) { {status: 'Captured'} }

            it_behaves_like 'dashboard controller tests'
        end

        describe 'my captured status' do
            let(:params) { {status: 'My Captured'} }

            it_behaves_like 'dashboard controller tests'
        end

        describe 'my closed status' do
            let(:params) { { status: 'My Closed'} }

            it_behaves_like 'dashboard controller tests'
        end

        describe 'no status' do
            let(:params) { {status: ''} }

            it_behaves_like 'dashboard controller tests'
        end
    end
end