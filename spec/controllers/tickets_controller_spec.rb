require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
    let(:user) { instance_double(User, admin?: false, organization: instance_double(Organization, approved?: true)) }
    let(:admin) { instance_double(User, admin?: true) }
    let(:ticket) { instance_double(Ticket, id: 1, name: "Test Ticket", phone: "123-456-7890") }

    before do
        allow(controller).to receive(:authenticate_admin)
        allow(controller).to receive(:current_user).and_return(user)
        allow(Ticket).to receive(:find_by).with(id: "1").and_return(ticket)
    end

    describe 'new' do
        it 'initializes a new ticket' do
            allow(Ticket).to receive(:new).and_return(ticket)

            subject.new

            expect(Ticket).to have_received(:new)
            expect(subject.instance_variable_get(:@ticket)).to eq(ticket)
        end
  end

    describe 'create' do
        let(:valid_params) do
            ActionController::Parameters.new(ticket: { 
            name: "Valid Ticket", 
            phone: "1234567890", 
            description: "Test description", 
            region_id: 1, 
            resource_category_id: 1 
            }).permit!
        end

        before do
            allow(controller).to receive(:params).and_return(valid_params)
            allow(Ticket).to receive(:new).and_return(ticket)
            allow(ticket).to receive(:phone=)
        end

        context 'when ticket is valid' do
            before do
                allow(ticket).to receive(:save).and_return(true)
            end

            it 'creates a ticket and redirects' do
                expect(subject).to receive(:redirect_to).with(ticket_submitted_path)

                subject.create

                expect(Ticket).to have_received(:new)
                expect(ticket).to have_received(:save)
            end
        end

        context 'when ticket is invalid' do
            before do 
                allow(ticket).to receive(:save).and_return(false)
            end
        
            it 'renders the new template' do
                expect(subject).to receive(:render).with(:new)
                subject.create
                expect(Ticket).to have_received(:new)
                expect(ticket).to have_received(:save)
            end
        end
    end

    describe 'show' do
        before do
            allow(Ticket).to receive(:find_by).and_return(ticket)
        end

        context 'when user is unauthorized' do
            before do
                allow(user.organization).to receive(:approved?).and_return(false)
                allow(user).to receive(:admin?).and_return(false)
            end

            it 'redirects to the dashboard' do
                expect(subject).to receive(:redirect_to).with(dashboard_path)
                subject.show
            end
        end

        context 'when user is authorized' do
            it 'sets the ticket instance variable' do
                subject.show
                expect(subject.instance_variable_get(:@ticket)).to eq(ticket)
            end
        end
    end

    describe 'capture' do
        before do 
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new(id: "1"))
            allow(Ticket).to receive(:find_by).with(id: "1").and_return(ticket)
            allow(TicketService).to receive(:capture_ticket).with(ticket.id, user).and_return(:ok)
        end

        it 'captures the ticket and redirects' do
            expect(subject).to receive(:redirect_to).with("#{dashboard_path}#tickets:open")
            subject.capture
            expect(TicketService).to have_received(:capture_ticket).with(ticket.id, user)
        end

        context 'when capture fails' do
            before do 
                allow(TicketService).to receive(:capture_ticket).and_return(:error)
            end

            it 'renders show' do
                expect(subject).to receive(:render).with(:show)
                subject.capture
            end
        end
    end

    describe 'release' do
        before do 
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new(id: "1"))
            allow(Ticket).to receive(:find_by).with(id: "1").and_return(ticket)
            allow(TicketService).to receive(:release_ticket).with(ticket.id, user).and_return(:ok)
        end

        context 'when user is an admin' do
            before do 
                allow(user).to receive(:admin?).and_return(true)
            end

            it 'redirects to the captured tickets section' do
                expect(subject).to receive(:redirect_to).with("#{dashboard_path}#tickets:captured")
                subject.release
            end
        end

        context 'when user is an organization member' do
            it "redirects to the organization's tickets section" do
                expect(subject).to receive(:redirect_to).with("#{dashboard_path}#tickets:organization")
                subject.release
            end
        end

        context 'when release fails' do
            before do 
                allow(TicketService).to receive(:release_ticket).and_return(:error)
            end

            it 'renders show' do
                expect(subject).to receive(:render).with(:show)
                subject.release
            end
        end
    end

    describe 'close' do
        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new(id: "1"))
            allow(Ticket).to receive(:find_by).with(id: "1").and_return(ticket)
            allow(TicketService).to receive(:close_ticket).with(ticket.id, user).and_return(:ok)
        end
      
        context 'when user is not authorized' do
            before do
                allow(user.organization).to receive(:approved?).and_return(false)
                allow(user).to receive(:admin?).and_return(false)
            end
        
            it 'redirects to the dashboard' do
                expect(subject).to receive(:redirect_to).with(dashboard_path)           
                subject.close
            end
        end
      
        context 'when ticket is not found' do
            before do 
                allow(Ticket).to receive(:find_by).with(id: "1").and_return(nil)
            end
        
            it 'redirects to the dashboard with an alert message' do
                expect(subject).to receive(:redirect_to).with(dashboard_path, alert: "Ticket not found.")
                subject.close
            end
        end
      
        context 'when user is an admin' do
            before do 
                allow(user).to receive(:admin?).and_return(true)
            end
        
            it 'redirects to the open tickets section' do
                expect(subject).to receive(:redirect_to).with("#{dashboard_path}#tickets:open")
                subject.close
            end
        end
      
        context 'when user is an organization member' do
            it "redirects to the organization's tickets section" do
                expect(subject).to receive(:redirect_to).with("#{dashboard_path}#tickets:organization")
                subject.close
            end
        end
      
        context 'when closing the ticket fails' do
            before do 
                allow(TicketService).to receive(:close_ticket).and_return(:error)
            end
        
            it 'renders show' do
                expect(subject).to receive(:render).with(:show)      
                subject.close
            end
        end
    end
    
    describe 'destroy' do
        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new(id: "1"))
        end
      
        context 'when the ticket exists' do
            before do
                allow(Ticket).to receive(:find_by).with(id: "1").and_return(ticket)
                allow(ticket).to receive(:destroy)
            end
      
            it 'destroys the ticket and redirects with a success message' do
                expect(ticket).to receive(:destroy)
                expect(subject).to receive(:redirect_to).with("#{dashboard_path}#tickets", notice: "Ticket #{ticket.id} was deleted.")
                subject.destroy
            end
        end
      
        context 'when the ticket does not exist' do
            before do 
                allow(Ticket).to receive(:find_by).with(id: "1").and_return(nil)
            end
        
            it 'redirects to the dashboard with an alert message' do
                expect(subject).to receive(:redirect_to).with(dashboard_path, alert: "Ticket not found.")
                subject.destroy
            end
        end
    end
end
