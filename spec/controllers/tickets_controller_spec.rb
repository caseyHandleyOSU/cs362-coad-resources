require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
    let!(:user) { create(:user) }
    let!(:ticket) { create(:ticket) }
    let!(:org) { create(:organization, :approved) }
    let!(:approved_user) { create(:user, organization_id: org.id)}
    let!(:admin) { create(:user, :admin, organization_id: org.id) }

    describe 'GET new' do

        context 'as a logged out user' do
            it 'redirects to dashboard' do
                get(:new)

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an un-approved user' do
            it 'verifies the request was a success' do
                sign_in user

                get(:new)

                expect(response).to be_successful
            end
        end

        context 'as an approved user' do
            it 'verifies the request was a success' do
                sign_in approved_user

                get(:new)

                expect(response).to be_successful
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

    describe 'PUT create' do

        context 'as a logged out user' do
            it 'redirects to login' do
                put(:create, params: {ticket: attributes_for(:ticket, :with_category, :with_region)})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an un-approved user' do
            context 'when ticket.save' do
                it 'redirects to dashboard' do
                    sign_in user

                    put(:create, params: {ticket: attributes_for(:ticket, :with_category, :with_region)})

                    expect(response).to redirect_to(ticket_submitted_path)
                end
            end

            context 'when not ticket.save' do
                it 'renders the new template' do
                    sign_in user

                    allow_any_instance_of(Ticket).to receive(:save).and_return(false)

                    expect(controller).to receive(:render).with(:new)

                    put(:create, params: {ticket: attributes_for(:ticket, :with_category, :with_region)})
                end
            end
        end

        context 'as an approved user' do
            
            context "when 'ticket.save" do
                it 'redirects to ticket_submitted_path' do
                    sign_in approved_user

                    put(:create, params: {ticket: attributes_for(:ticket, :with_category, :with_region)})

                    expect(response).to redirect_to(ticket_submitted_path)
                end
            end

            context "when not 'ticket.save" do
                it 'verifies the request was a success' do
                    sign_in approved_user

                    allow_any_instance_of(Ticket).to receive(:save).and_return(false)

                    expect(response).to be_successful
                end 
            end
                
        end

        context 'as an approved user' do

            context "when ticket.save" do
                it 'redirects to ticket_submitted_path' do
                    sign_in approved_user

                    put(:create, params: {ticket: attributes_for(:ticket, :with_category, :with_region)})

                    expect(response).to redirect_to(ticket_submitted_path)
                end
            end

            context "when not 'ticket.save" do
                it 'verifies the request was a success' do
                    sign_in approved_user

                    allow_any_instance_of(Ticket).to receive(:save).and_return(false)

                    put(:create, params: {ticket: attributes_for(:ticket, :with_category, :with_region)})

                    expect(response).to be_successful
                end
            end
        end

        context 'as an admin' do

            context "when ticket.save" do
                it 'redirects to ticket_submitted_path' do
                    sign_in admin

                    put(:create, params: {ticket: attributes_for(:ticket, :with_category, :with_region)})

                    expect(response).to redirect_to(ticket_submitted_path)
                end
            end

            context "when not 'ticket.save" do
                it 'renders the new template' do
                    sign_in admin

                    allow_any_instance_of(Ticket).to receive(:save).and_return(false)

                    put(:create, params: {ticket: attributes_for(:ticket, :with_category, :with_region)})

                    expect(response).to be_successful
                end
            end
        end
    end

    describe 'GET show' do

        context 'as a logged out user' do
            it 'redirects to login' do
                get(:show, params: {id: ticket.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an un-approved user' do
            it 'redirect to dashboard' do
                sign_in user

                get(:show, params: {id: ticket.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an approved user' do
            it 'verifies the request was a success' do
                sign_in approved_user

                get(:show, params: {id: ticket.id})
                
                expect(response).to be_successful
            end
        end

        context 'as an admin' do
            it 'verifies the request was a success' do
                sign_in admin

                get(:show, params: {id: ticket.id})
                
                expect(response).to be_successful
            end
        end
    end

    describe 'PUT capture' do

        context 'as a logged out user' do
            it 'redirects to login' do
                put(:capture, params: {id: ticket.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an un-approved user' do
            it 'redirects to dashboard' do
                sign_in user

                put(:capture, params: {id: ticket.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an approved user' do

            context 'with an owned ticket' do
                it 'redirects to dashboard_path#tickets_open' do
                    sign_in approved_user

                    put(:capture, params: {id: ticket.id})

                    expect(response).to redirect_to(dashboard_path << "#tickets:open")
                end 
            end
            
            context 'with anothers ticket' do
                it 'does not redirect' do
                    sign_in approved_user
                    some_org = create(:organization, :approved)
                    new_ticket = create(:ticket, organization_id: some_org.id)

                    put(:capture, params: {id: new_ticket.id})

                    expect(response).not_to redirect_to(dashboard_path << "#tickets:open")
                end
            end 
        end 

        context 'as an admin' do

            context 'with an owned ticket' do
                it 'redirects to dashboard_path#tickets_open' do
                    sign_in admin

                    put(:capture, params: {id: ticket.id})

                    expect(response).to redirect_to(dashboard_path << "#tickets:open")
                end 
            end
            
            context 'with anothers ticket' do
                it 'does not redirect' do
                    sign_in admin
                    some_org = create(:organization, :approved)
                    ticket = create(:ticket, organization_id: some_org.id)

                    put(:capture, params: {id: ticket.id})

                    expect(response).not_to redirect_to(dashboard_path << "#tickets:open")
                end
            end 
        end

    end

    describe 'PUT release' do

        context 'as a logged out user' do
            it 'redirects to login' do
                put(:release, params: {id: ticket.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an un-approved user' do
            it 'redirects to dashboard' do
                sign_in user 

                put(:release, params: {id: ticket.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end

        context 'as an approved user' do
            
            context 'with an owned ticket' do
                it 'redirects to tickets:organization' do
                    sign_in approved_user

                    allow(TicketService).to receive(:release_ticket).and_return(:ok)

                    put(:release, params: {id: ticket.id})

                    expect(response).to redirect_to(dashboard_path << "#tickets:organization")
                end
            end

            context 'with anothers ticket' do
                it 'verifies the request was a success' do
                    sign_in approved_user

                    new_ticket = create(:ticket)

                    post(:release, params: {id: new_ticket.id})

                    expect(response).to be_successful
                end
            end
        end

        context 'as an admin' do

            context 'with an owned ticket' do
                it 'redirects to tickets:captured' do
                    sign_in admin
                    some_ticket = create(:ticket, organization_id: org.id)

                    post(:release, params: {id: some_ticket.id})

                    expect(response).to redirect_to(dashboard_path << "#tickets:captured")
                end
            end

            context 'with anothers ticket' do
                it 'redirects to tickets:captured' do
                    sign_in admin

                    post(:release, params: {id: ticket.id})

                    expect(response).to redirect_to(dashboard_path << "#tickets:captured")
                end
            end
        end

    end

    describe 'PATCH close' do

        context 'as a logged out user' do
            it 'redirects to dashboard' do
                patch(:close, params: {id: ticket.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an un-approved user' do
            it 'redirects to dashboard' do
                sign_in user

                patch(:close, params: {id: ticket.id})

                expect(response).to redirect_to(dashboard_path)
            end
        end
    

        context 'as an approved user' do

            context 'with owned ticket' do
                it 'redirects to tickets:organization' do
                    sign_in approved_user
                    some_ticket = create(:ticket, organization_id: org.id)

                    patch(:close, params: {id: some_ticket.id})

                    expect(response).to redirect_to(dashboard_path << "#tickets:organization")
                end
            end

            context 'with anothers ticket' do
                it 'verifies the request was a success' do
                    sign_in approved_user

                    patch(:close, params: {id: ticket.id})

                    expect(response).to be_successful
                end
            end
        end

        context 'as an admin' do

            context 'with owned ticket' do
                it 'redirects to tickets:open' do
                    sign_in admin
                    some_ticket = create(:ticket, organization_id: org.id)

                    patch(:close, params: {id: some_ticket.id})

                    expect(response).to redirect_to(dashboard_path << "#tickets:open")
                end
            end

            context 'with anothers ticket' do
                it 'redirects to tickets:open' do
                    sign_in admin

                    patch(:close, params: {id: ticket.id})

                    expect(response).to redirect_to(dashboard_path << "#tickets:open")
                end
            end
        end
    end

    describe 'DELETE destroy' do

        context 'as a logged out user' do
            it 'redirects to login' do
                delete(:destroy, params: {id: ticket.id})

                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context 'as an un-approved user' do
            it 'is unsuccessfull' do
                sign_in user

                delete(:destroy, params: {id: ticket.id})

                expect(response).not_to be_successful
            end
        end

        context 'as an approved user' do
            it 'is unsuccessfull' do
                sign_in approved_user

                delete(:destroy, params: {id: ticket.id})

                expect(response).not_to be_successful
            end
        end

        context 'as an admin' do
            it 'redirects to tickets' do
                sign_in admin

                delete(:destroy, params: {id: ticket.id})

                expect(response).to redirect_to(dashboard_path << "#tickets")
            end
        end
    end
end 
