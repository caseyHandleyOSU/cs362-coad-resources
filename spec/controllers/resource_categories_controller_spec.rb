require 'rails_helper'

RSpec.describe ResourceCategoriesController, type: :controller do
    let!(:user) { create(:user) }
    let!(:admin) { create(:user, :admin)}
    let!(:resource_category) { create(:resource_category) }

    describe 'GET index' do
        
        context 'as a logged out user' do
            it 'redirects to login' do
                get(:index)

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user

                get(:index)

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do
            it 'verifies the request was a success' do
                sign_in admin

                get(:index)

                expect(response).to be_successful 
            end
        end 
    end

    describe 'GET show' do

        context 'as a logged out user' do
            it 'redirects to login' do
                get(:show, params: {id: resource_category.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user

                get(:show, params: {id: resource_category.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do
            it 'verifies the request was a success' do
                sign_in admin

                get(:show, params: {id: resource_category.id})

                expect(response).to be_successful 
            end
        end
    end

    describe 'GET new' do

        context 'as a logged out user' do
            it 'redirects to login' do

                get(:new)

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user

                get(:new)

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do
            it 'verifies the request was a success' do
                sign_in admin

                get(:new)

                expect(response).to be_successful
            end
        end
    end

    describe 'POST create' do

        context 'as a logged out user' do
            it 'redirects to login' do
                post(:create, params: {resource_category: attributes_for(:resource_category)})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user

                post(:create, params: {resource_category: attributes_for(:resource_category)})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do

            context " when 'resource_category.save" do
                it 'redirects to resource_categories_path' do
                    sign_in admin

                    post(:create, params: {resource_category: attributes_for(:resource_category)})

                    expect(response).to redirect_to(resource_categories_path)
                    expect(flash[:notice]).to eq('Category successfully created.')
                end
            end

            context " when not 'resource_category.save" do
                it 'renders the new template' do
                    sign_in admin

                    allow_any_instance_of(ResourceCategory).to receive(:save).and_return(false)

                    expect(controller).to receive(:render).with(:new)

                    post(:create, params: {resource_category: attributes_for(:resource_category)})
                end
            end
        end
    end 

    describe 'GET edit' do

        context 'as a logged out user' do
            it 'redirects to login' do
                get(:edit, params: { id: resource_category.id })

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user 

                get(:edit, params: { id: resource_category.id })

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do
            it 'verifies the request was a success' do
                sign_in admin

                get(:edit, params: { id: resource_category.id })

                expect(response).to be_successful
            end
        end
    end

    describe 'PUT update' do

        context 'as a logged out user' do
            it 'redirects to login' do
                put(:update, params: {id: resource_category.id, resource_category: attributes_for(:resource_category)})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user

                put(:update, params: {id: resource_category.id, resource_category: attributes_for(:resource_category)})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do

            context "when resource_category.update(resource_category_params)" do
                it 'redirects to resource_category' do
                    sign_in admin

                    put(:update, params: {id: resource_category.id, resource_category: attributes_for(:resource_category)})

                    expect(response).to redirect_to(resource_category)
                    expect(flash[:notice]).to eq('Category successfully updated.')
                end
            end

            context "when not resource_category.update(resource_category_params)" do
                it 'renders the edit template' do
                    sign_in admin

                    allow_any_instance_of(ResourceCategory).to receive(:update).and_return(false)

                    expect(controller).to receive(:render).with(:edit)

                    put(:update, params: {id: resource_category.id, resource_category: attributes_for(:resource_category)})
                end
            end
        end         
    end

    describe 'PUT activate' do

        context 'as a logged out user' do
            it 'redirects to login' do
                put(:activate, params: {id: resource_category.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user

                put(:activate, params: {id: resource_category.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do

            context "when 'resource_category.activate" do
                it 'redirects to resource_category' do
                    sign_in admin

                    put(:activate, params: {id: resource_category.id})

                    expect(response).to redirect_to(resource_category)
                    expect(flash[:notice]).to eq('Category activated.')
                end
            end

            context "when not 'resource_category.activate" do
                it 'redirects to resource category' do
                    sign_in admin

                    allow_any_instance_of(ResourceCategory).to receive(:activate).and_return(false)

                    put(:activate, params: {id: resource_category.id})

                    expect(response).to redirect_to(resource_category)
                    expect(flash[:alert]).to eq('There was a problem activating the category.')
                end
            end
        end
    end

    describe 'PUT deactivate' do

        context 'as a logged out user' do
            it 'redirects to login' do
                put(:deactivate, params: {id: resource_category.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user

                put(:deactivate, params: {id: resource_category.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do
            
            context "when 'resource_category.deactivate'" do
                it 'redirects to resource_category' do
                    sign_in admin

                    put(:deactivate, params: {id: resource_category.id})

                    expect(response).to redirect_to(resource_category)
                    expect(flash[:notice]).to eq('Category deactivated.')
                end
            end

            context "when not 'resource_category.deactivate" do
                it 'redirects to resource_category with an alert' do
                    sign_in admin

                    allow_any_instance_of(ResourceCategory).to receive(:deactivate).and_return(false)

                    put(:deactivate, params: {id: resource_category.id})

                    expect(response).to redirect_to(resource_category)
                    expect(flash[:alert]).to eq('There was a problem deactivating the category.')
                end
            end
        end

    end

    describe 'DELETE destroy' do

        context 'as a logged out user' do
            it 'redirects to login' do
                delete(:destroy, params: {id: resource_category.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user

                delete(:destroy, params: {id: resource_category.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do
            it 'redirects to resource_categories_path' do
                sign_in admin

                delete(:destroy, params: {id: resource_category.id})

                expect(response).to redirect_to(resource_categories_path)
                expect(flash[:notice]).to eq("Category #{resource_category.name} was deleted.\nAssociated tickets now belong to the 'Unspecified' category.")
            end
        end
    end
end
