require 'rails_helper'
 
RSpec.describe OrganizationsController, type: :controller do
    let!(:user) { create(:user) }
    let!(:organization) { create(:organization) }
    let!(:approved_org) { create(:organization, :approved) }
    let!(:approved_user) { create(:user, organization_id: approved_org.id) }
    let!(:admin) { create(:user, :admin) }

    describe 'GET index' do

        context 'as a approved user' do
            it 'verifies the request was a success' do
                sign_in approved_user 
                
                get(:index)
                expect(response).to be_successful
            end
        end

        context 'as an unapproved user' do
            it 'verifies the request was a success' do
                sign_in user

                get(:index)
                expect(response).to be_successful
            end
        end

        context 'as a logged out user' do
            it 'redirects to login' do
                get(:index)

                expect(response).not_to be_successful
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an admin user' do
            it 'verifies the request was a success' do
                sign_in admin

                get(:index)
                expect(response).to be_successful
            end
        end
    end

    describe 'GET new' do

        context 'as an approved user' do
            it 'redirects to dashboard' do
                sign_in approved_user

                get(:new)
                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an unapproved user' do
            it 'verifies the request was a success' do
                sign_in user

                get(:new)
                expect(response).to be_successful
            end
        end

        context 'as a logged out user' do
            it 'redirects to login' do
                get(:new)

                expect(response).not_to be_successful
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an admin user' do
            it 'verifies the request was not a success' do
                sign_in admin

                get(:new)

                expect(response).not_to be_successful
            end
        end
    end

    describe 'POST create' do

        context 'as an approved user' do
            it 'redirects to dashboard' do
                sign_in approved_user

                post(:create, params: {organization: FactoryBot.attributes_for(:organization)})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an unapproved user' do

            context 'when organization.save and current_user.save' do
                it 'redirects to organization application submitted path' do
                    sign_in user

                    post(:create, params: {organization: FactoryBot.attributes_for(:organization)})

                    expect(response).to redirect_to(organization_application_submitted_path)
                end
            end

            context 'when not organization.save and current_user.save' do
                it 'renders the new template' do
                    sign_in user

                    allow(Organization).to receive(:new).and_return(double('Organization', save: false, valid?: false))

                    expect(controller).to receive(:render).with(:new)
                    post(:create, params: {organization: FactoryBot.attributes_for(:organization)})                  
                end
            end
        end

        context 'as a logged out user' do
            it 'redirects to login' do

                post(:create, params: {organization: FactoryBot.attributes_for(:organization)})

                expect(response).not_to be_successful
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an admin user' do
            it 'verifies the request was not a success' do
                sign_in admin

                post(:create, params: {organization: FactoryBot.attributes_for(:organization)})

                expect(response).not_to be_successful
            end
        end
    end

    describe 'GET edit' do

        context 'as an approved user' do
            it 'verifies the request was a success' do
                sign_in approved_user

                get(:edit, params: {id: organization.id, organization: FactoryBot.attributes_for(:organization)})

                expect(response).to be_successful
            end
        end

        context 'as an unapproved user' do
            it 'verifies the request was not a success' do
                sign_in user

                get(:edit, params: {id: organization.id, organization: FactoryBot.attributes_for(:organization)})

                expect(response).not_to be_successful
            end
        end

        context 'as a logged out user' do
            it 'redirects to login' do

                get(:edit, params: {id: organization.id, organization: FactoryBot.attributes_for(:organization)})

                expect(response).to redirect_to(new_user_session_path)
            end 
        end

        context 'as an admin user' do
            it 'verifies the request was not a success' do

                sign_in admin

                get(:edit, params: {id: organization.id, organization: FactoryBot.attributes_for(:organization)})

                expect(response).not_to be_successful
            end
        end
  
    end

    describe 'PATCH update' do

        context 'as an approved user' do
            context 'when organization.update(organization_params)' do
                it 'redirects to organization page' do
                    sign_in approved_user

                    patch(:update, params: { id: organization.id, organization: FactoryBot.attributes_for(:organization)})

                    expect(response).to redirect_to(organization_path(id: organization.id))
                end
            end

            context 'when not organization.update(organization_params)' do
                it 'renders the edit template' do
                    sign_in approved_user

                    allow_any_instance_of(Organization).to receive(:update).and_return(false)

                    expect(controller).to receive(:render).with(:edit)

                    patch(:update, params: { id: organization.id, organization: FactoryBot.attributes_for(:organization)})
                end
            end
        end

        context 'as an unapproved user' do
            it 'redirects to dashboard' do
                sign_in user

                patch(:update, params: { id: organization.id, organization: FactoryBot.attributes_for(:organization)})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as a logged out user' do
            it 'redirects to login' do

                patch(:update, params: { id: organization.id, organization: FactoryBot.attributes_for(:organization)})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an admin user' do
            it 'verifies the request was a not success' do
                sign_in admin

                patch(:update, params: { id: organization.id, organization: FactoryBot.attributes_for(:organization)})

                expect(response).not_to be_successful
            end
        end
    end

    describe 'GET show' do

        context 'as an approved user' do
            it 'verifies the request was a success' do
                sign_in approved_user

                get(:show, params: {id: organization.id})

                expect(response).to be_successful
            end
        end

        context 'as an unapproved user' do
            it 'verifies the request was not a success' do
                sign_in user
                
                get(:show, params: {id: organization.id})

                expect(response).not_to be_successful
            end
        end

        context 'as a logged out user' do
            it 'redirect to login' do
                get(:show, params: {id: organization.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an admin' do
            it 'verifies the request was a success' do
                sign_in admin

                get(:show, params: {id: organization.id})

                expect(response).to be_successful
            end
        end
    end

    describe 'POST approve' do

        context 'as an approved user' do
            it 'redirects to dashboard' do
                sign_in approved_user

                post(:approve, params: {id: organization.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an unapproved user' do
            it 'redirects to dashboard' do
                sign_in user

                post(:approve, params: {id: organization.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as a logged out user' do
            it 'redirects to login' do

                post(:approve, params: {id: organization.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an admin user' do

            context 'if organization.save' do 
                it 'redirects to organization path' do
                    sign_in admin

                    post(:approve, params: {id: organization.id})

                    expect(response).to redirect_to(organizations_path)
                    expect(flash[:notice]).to eq("Organization #{organization.name} has been approved.")
                end
            end

            context 'if not organization.save' do
                it 'redirects to organization path' do
                    sign_in admin

                    allow_any_instance_of(Organization).to receive(:save).and_return(false)

                    post(:approve, params: { id: organization.id})

                    expect(response).to redirect_to(organization_path(id: organization.id))
                end
            end
        end


    end

    describe 'POST reject' do

        context 'as an approved user' do
            it 'redirects to dashboard' do
                sign_in approved_user

                post(:reject, params: {id: organization.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an unapproved user' do
            it 'redirects to dashboard' do
                sign_in user

                post(:reject, params: {id: organization.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as a logged out user' do
            it 'redirects to login' do

                post(:reject, params: {id: organization.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an admin user' do

            context 'if organization.save' do
                it 'redirects to organizations path' do
                    sign_in admin

                    post(:reject, params: {id: organization.id, organization: {rejection_reason: 'Not qualified'}})

                    expect(response).to redirect_to(organizations_path)
                    expect(flash[:notice]).to eq("Organization #{organization.name} has been rejected.")
                end
            end

            context 'if not organization.save' do
                it 'redirects to organization path' do
                    sign_in admin

                    allow_any_instance_of(Organization).to receive(:save).and_return(false)

                    post(:reject, params: {id: organization.id, organization: {rejection_reason: 'Not qualified'}})

                    expect(response).to redirect_to(organization_path(id: organization.id))
                end
            end
        end
    end
end
