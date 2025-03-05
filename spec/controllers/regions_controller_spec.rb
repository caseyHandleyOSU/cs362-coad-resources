require 'rails_helper'

RSpec.describe RegionsController, type: :controller do
    let!(:user) { create(:user) }
    let!(:region) { create(:region) }
    let!(:admin) { create(:user, :admin) }

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
                get(:show, params: {id: region.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user
                get(:show, params: {id: region.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do
            it 'verifies the request was a success' do
                sign_in admin

                get(:show, params: {id: region.id})

                expect(response).to be_successful
            end
        end
    end

    describe 'GET new' do

        context 'as a logged out user' do
            it 'redirects to login' do

                get(:new, params: {id: region.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user

                get(:new, params: {id: region.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do
            it 'verifies the request was a success' do
                sign_in admin

                get(:new, params: {id: region.id})

                expect(response).to be_successful
            end
        end
    end

    describe 'POST create' do

        context 'as a logged out user' do
            it 'redirects to login' do
                post(:create, params: {region: attributes_for(:region)})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user 

                post(:create, params: {region: attributes_for(:region)})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do

            context 'if region.save' do
                it 'redirects to regions_path' do
                    sign_in admin

                    post(:create, params: {region: attributes_for(:region)})

                    expect(response).to redirect_to(regions_path)
                    expect(flash[:notice]).to eq('Region successfully created.')
                end
            end
            
            context 'if not region.save' do
                it 'renders the new template' do
                    sign_in admin

                    allow_any_instance_of(Region).to receive(:save).and_return(false)

                    expect(controller).to receive(:render).with(:new)

                    post(:create, params: {region: attributes_for(:region)})
                end
            end
        end

    end

    describe 'GET edit' do

        context 'as a logged out user' do
            it 'redirects to login' do
                get(:edit, params: {id: region.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user

                get(:edit, params: {id: region.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do
            it 'verifies the request was a success' do
                sign_in admin

                get(:edit, params: {id: region.id})

                expect(response).to be_successful 
            end
        end
    end

    describe 'PUT update' do

        context 'as a logged out user' do
            it 'redirects to login' do

                put(:update, params: {id: region.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dahsboard' do
                sign_in user

                put(:update, params: {id: region.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do

            context "when 'region.update(region_params)'" do
                it 'redirects to region' do
                    sign_in admin

                    put(:update, params: {id: region.id, region: {name: 'Updated name'}})

                    expect(response).to redirect_to(region)
                    expect(flash[:notice]).to eq('Region successfully updated.')
                end
            end

            context "when not 'region.update(region_params)" do
                it 'renders the edit template' do
                    sign_in admin

                    allow_any_instance_of(Region).to receive(:update).and_return(false)

                    expect(controller).to receive(:render).with(:edit)

                    put(:update, params: {id: region.id, region: {name: 'Updated name'}})
                end
            end
        end
    end

    describe 'DELETE destroy' do

        context 'as a logged out user' do
            it 'redirects to login' do
                delete(:destroy, params: {id: region.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as a logged in user' do
            it 'redirects to dashboard' do
                sign_in user

                delete(:destroy, params: {id: region.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an admin' do
            it 'redirects to login' do
                sign_in admin
                
                delete(:destroy, params: {id: region.id})

                expect(response).to redirect_to(regions_path)
                expect(flash[:notice]).to eq("Region #{region.name} was deleted. Associated tickets now belong to the 'Unspecified' region.")
            end
        end
    end
end

