require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
    let(:user) { instance_double(User, admin?: false, organization: nil) }

    before do
        allow(controller).to receive(:authenticate_user!)
        allow(controller).to receive(:current_user).and_return(user)
    end

    describe 'index' do
        let(:tickets_mock) { double("Tickets") }
        let(:pagy_mock) { instance_double(Pagy) }

        before do
            allow(Ticket).to receive(:all).and_return(tickets_mock)
            allow(controller).to receive(:pagy).with(tickets_mock, items: 10).and_return([pagy_mock, tickets_mock])
        end
        
        context 'when user is an admin' do
            let(:user) { instance_double(User, admin?: true, organization: nil) }

            it "sets status_options to ['Open', 'Captured', 'Closed]" do
                subject.index
                expect(subject.instance_variable_get(:@status_options)).to eq(['Open', 'Captured', 'Closed'])
            end
        end

        context 'when user belongs to an approved organization' do
            let(:organization) { instance_double(Organization, approved?: true) }
            let(:user) { instance_double(User, admin?: false, organization: organization) }

            it "sets status_options to ['Open, 'My Captured', 'My Closed']" do
                subject.index
                expect(subject.instance_variable_get(:@status_options)).to eq(['Open', 'My Captured', 'My Closed'])
            end
        end

        context 'when a user does not belong to an approved organization' do
            let(:organization) { instance_double(Organization, approved?: false) }
            let(:user) { instance_double(User, admin?: false, organization: organization) }

            it "sets status_options to ['Open']" do
                subject.index
                expect(subject.instance_variable_get(:@status_options)).to eq(['Open'])
            end
        end

        context 'when filtering tickets by status' do
            before do
                allow(Ticket).to receive(:open).and_return(tickets_mock)
                allow(Ticket).to receive(:closed).and_return(tickets_mock)
                allow(Ticket).to receive(:all_organization).and_return(tickets_mock)
                allow(Ticket).to receive(:organization).and_return(tickets_mock)
                allow(Ticket).to receive(:closed_organization).and_return(tickets_mock)
            end

            it "gets open tickets when status is 'Open'" do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({status: 'Open'}))
                subject.index
                expect(Ticket).to have_received(:open)
            end

            it "gets closed tickes when status is 'Closed'" do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({status: 'Closed'}))
                subject.index
                expect(Ticket).to have_received(:closed)
            end

            it "gets user organization closed tickets when status is 'My Closed'" do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({status: 'My Closed'}))
                subject.index
                expect(Ticket).to have_received(:closed_organization)
            end

            it "gets captured tickets when status is 'Captured'" do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({status: 'Captured'}))
                subject.index
                expect(Ticket).to have_received(:all_organization)
            end

            it "gets user organization tickets when status is 'My Captured'" do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({status: 'My Captured'}))
                subject.index
                expect(Ticket).to have_received(:organization)
            end
        end

        context 'when filtering by region and resource category' do
            let(:filtered_tickets) { double("Filtered Tickets") }

            before do
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