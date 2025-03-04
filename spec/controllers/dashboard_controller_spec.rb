require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
    let(:user) { create(:user) }

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
                user = create(:user, organization_id: org)
                sign_in user 
            }
            after(:each) { expect(response).to be_successful() }

            it 'index' do
                get :index, params: params
            end
        end

        describe 'admin user' do
            before(:each) {
                user = create(:user, :admin)
                sign_in user 
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

    describe 'filtering tickets' do
        let(:tickets_mock) { double("Tickets") }
        let(:pagy_mock) { instance_double(Pagy) }

        before do
            allow(Ticket).to receive(:all).and_return(tickets_mock)
            allow(controller).to receive(:pagy).with(tickets_mock, items: 10).and_return([pagy_mock, tickets_mock])
        end

        context 'when filtering tickets by status' do
            before do
                sign_in user
                allow(Ticket).to receive(:open).and_return(tickets_mock)
                allow(Ticket).to receive(:closed).and_return(tickets_mock)
                allow(Ticket).to receive(:all_organization).and_return(tickets_mock)
                allow(Ticket).to receive(:organization).and_return(tickets_mock)
                allow(Ticket).to receive(:closed_organization).and_return(tickets_mock)
            end

            it "Open" do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({status: 'Open'}))
                subject.index
                expect(Ticket).to have_received(:open)
            end

            it "Closed" do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({status: 'Closed'}))
                subject.index
                expect(Ticket).to have_received(:closed)
            end

            it "My Closed'" do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({status: 'My Closed'}))
                subject.index
                expect(Ticket).to have_received(:closed_organization)
            end

            it "Captured" do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({status: 'Captured'}))
                subject.index
                expect(Ticket).to have_received(:all_organization)
            end

            it "My Captured" do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({status: 'My Captured'}))
                subject.index
                expect(Ticket).to have_received(:organization)
            end
        end

        context 'when filtering by region and resource category' do
            let(:filtered_tickets) { double("Filtered Tickets") }

            before do
                sign_in user
                allow(Ticket).to receive(:all).and_return(tickets_mock)
                allow(tickets_mock).to receive(:region).and_return(filtered_tickets)
                allow(filtered_tickets).to receive(:resource_category).and_return(filtered_tickets)
            end

            it 'filters tickets by region and resource category if params are present' do
               allow(controller).to receive(:params).and_return(ActionController::Parameters.new({region_id: "1", resource_category_id: "2"}))
               subject.index
               expect(tickets_mock).to have_received(:region).with("1")
               expect(filtered_tickets).to have_received(:resource_category).with("2")
            end
        end

        context 'sorting tickets' do
            before do
                sign_in user
                allow(tickets_mock).to receive(:reverse).and_return(tickets_mock)
            end

            it "reverses the order if sort_order is 'Newest First'" do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({sort_order: 'Newest First'}))
                subject.index
                expect(tickets_mock).to have_received(:reverse)
            end
        end
    end
end