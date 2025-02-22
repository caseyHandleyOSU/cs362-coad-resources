require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
    let(:user) { instance_double(User, admin?: false, organization: nil) }
    let(:organization) { instance_double(Organization, id: 1, name: 'Test Organization', approved?: false) }

    before do
        allow(controller).to receive(:authenticate_user!)
        allow(controller).to receive(:current_user).and_return(user)
        allow(Organization).to receive(:find).and_return(organization)
    end

    describe 'index' do
        let(:organization_mock) { double("Organizations") }

        before do
            allow(Organization).to receive(:all).and_return(organization_mock)
            allow(organization_mock).to receive(:order).with(:name).and_return(organization_mock)
        end

        it 'fetches all organizations ordered by name' do
            subject.index
            expect(Organization).to have_received(:all)
            expect(organization_mock).to have_received(:order).with(:name)
        end
    end

    describe 'new' do
        before do
            allow(Organization).to receive(:new).and_return(organization)
        end

        it 'initializes a new organization' do
            subject.new
            expect(Organization).to have_received(:new)
            expect(subject.instance_variable_get(:@organization)).to eq(organization)
        end
    end

    describe 'create' do
        let(:new_organization) { instance_double(Organization, valid?: true, save: true) }

        before do
            allow(Organization).to receive(:new).and_return(new_organization)
            allow(user).to receive(:organization=)
            allow(user).to receive(:save).and_return(true)
            allow(new_organization).to receive(:save).and_return(true)
            allow(UserMailer).to receive_message_chain(:with, :new_organization_application, :deliver_now)
        end

        context 'when organization is valid' do
            it 'assigns the organization to the user and sends an email' do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({organization: {name: 'New Org'} }))
                expect(subject).to receive(:redirect_to).with(organization_application_submitted_path)
                subject.create
                expect(Organization).to have_received(:new)
                expect(user).to have_received(:save)
                expect(UserMailer).to have_received(:with)
            end
        end

        context 'when organization is invalid' do
            let(:invalid_organization) { instance_double(Organization, valid?: false, save: false) }

            before do
                allow(Organization).to receive(:new).and_return(invalid_organization)
            end

            it 'renders the new template' do
                allow(controller).to receive(:params).and_return(ActionController::Parameters.new({organization: {name: 'Invalid Org'} }))
                expect(subject).to receive(:render).with(:new)
                subject.create
            end
        end
    end

    describe 'edit' do
        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({id: 1}))
            allow(Organization).to receive(:find).with(1).and_return(organization)
        end

        it 'sets organization' do
            subject.send(:set_organization)
            subject.edit
            expect(subject.instance_variable_get(:@organization)).to eq(organization)
        end
    end

    describe 'update' do
        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({id: 1, organization: {name: 'Updated Org'}}))
            allow(Organization).to receive(:find).with(1).and_return(organization)
        end

        context 'when the update is a success' do
            before do
                allow(organization).to receive(:update).with({'name' => 'Updated Org'}).and_return(true)
            end

            it 'updates the organization and redirects' do
                subject.send(:set_organization)
                expect(subject).to receive(:redirect_to).with(organization_path(id: organization.id,))
                subject.update
                expect(organization).to have_received(:update).with({'name' => 'Updated Org'})
            end
        end

        context 'when the update fails' do
            before do
                allow(organization).to receive(:update).with({'name' => 'Updated Org'}).and_return(false)
            end

            it 'renders the edit template' do
                subject.send(:set_organization)
                expect(subject).to receive(:render).with(:edit)
                subject.update
                expect(organization).to have_received(:update).with({'name' => 'Updated Org'})
            end
        end
    end

    describe 'show' do
        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({id: 1}))
            allow(Organization).to receive(:find).with(1).and_return(organization)
        end

        it 'sets organization' do
            subject.send(:set_organization)
            subject.edit
            expect(subject.instance_variable_get(:@organization)).to eq(organization)
        end
    end

    describe 'approve' do
        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({ id: 1 }))
            allow(Organization).to receive(:find).with(1).and_return(organization)
            allow(organization).to receive(:approve)
        end
        
        context 'when save is successful' do
            before do
                allow(organization).to receive(:save).and_return(true)
            end

            it 'approves the organization and redirects' do
                expect(subject).to receive(:redirect_to).with(organizations_path, notice: "Organization #{organization.name} has been approved.")
                subject.send(:set_organization)
                subject.approve 
                expect(organization).to have_received(:approve)
                expect(organization).to have_received(:save)
            end
        end

        context 'when save fails' do
            before do
                allow(organization).to receive(:save).and_return(false)
            end

            it 'redirects to organization' do
                expect(subject).to receive(:redirect_to).with(organization_path(id: organization.id))
                subject.send(:set_organization)
                subject.approve
                expect(organization).to have_received(:approve)
                expect(organization).to have_received(:save)
            end
        end 
    end

    describe 'reject' do
        before do
          allow(controller).to receive(:params).and_return(ActionController::Parameters.new({ id: 1, organization: {rejection_reason: 'Incomplete Application'} }))
          allow(Organization).to receive(:find).with(1).and_return(organization)
        end
      
        context 'when rejection is successful' do
            before do
                allow(organization).to receive(:reject)
                allow(organization).to receive(:rejection_reason=).with('Incomplete Application')
                allow(organization).to receive(:save).and_return(:true)
            end

            it 'rejects the organization with a rejection reason and redirects' do
                expect(subject).to receive(:redirect_to).with(organizations_path, notice: "Organization #{organization.name} has been rejected.")
                subject.send(:set_organization)
                subject.reject
                expect(organization).to have_received(:reject)
                expect(organization).to have_received(:rejection_reason=).with('Incomplete Application')
                expect(organization).to have_received(:save)
            end
        end

        context "when rejection fails" do
            before do
                allow(organization).to receive(:reject)
                allow(organization).to receive(:rejection_reason=).with("Incomplete Application")
                allow(organization).to receive(:save).and_return(false)
            end
        
            it "renders the organization page if save fails" do
                expect(subject).to receive(:redirect_to).with(organization_path(id: organization.id))
                subject.send(:set_organization)
                subject.reject
                expect(organization).to have_received(:reject)
                expect(organization).to have_received(:rejection_reason=).with("Incomplete Application")
                expect(organization).to have_received(:save)
            end
        end
    end
    
    describe "verify_unapproved" do
        context "when user has no organization" do
            before do
                allow(user).to receive(:organization?).and_return(false)
                allow(user).to receive(:organization).and_return(nil)
                allow(subject).to receive(:redirect_to)
            end
        
            it "allows access" do
                expect(subject.send(:verify_unapproved)).to be_nil
            end
        end
        
        context "when user already has an organization" do
            before do
                allow(user).to receive(:organization?).and_return(true)
                allow(user).to receive(:organization).and_return(organization)
                allow(subject).to receive(:redirect_to)
            end
        
            it "redirects to the dashboard" do
                expect(subject).to receive(:redirect_to).with(dashboard_path)
                subject.send(:verify_unapproved)
            end
        end
    end

    describe "verify_approved" do
        context "when user belongs to an approved organization" do
            before do
                allow(user).to receive(:organization).and_return(organization)
                allow(organization).to receive(:approved?).and_return(true)
            end

            it "allows access" do
                expect(subject.send(:verify_approved)).to be_nil
            end
        end

        context "when user does not belong to an approved organization" do
            before do
                allow(user).to receive(:organization).and_return(organization)
                allow(organization).to receive(:approved?).and_return(false)
            end

            it "redirects to the dashboard" do
                expect(subject).to receive(:redirect_to).with(dashboard_path)
                subject.send(:verify_approved)
            end
        end
    end

    describe "verify_user" do
        context "when user is an admin" do
            before do
                allow(user).to receive(:admin?).and_return(true)
            end

            it "allows access" do
                expect(subject.send(:verify_user)).to be_nil
            end
        end

        context "when user belongs to an approved organization" do
            before do
                allow(user).to receive(:admin?).and_return(false)
                allow(user).to receive(:organization).and_return(organization)
                allow(organization).to receive(:approved?).and_return(true)
            end

            it "allows access" do
                expect(subject.send(:verify_user)).to be_nil
            end
        end

        context "when user does not meet requirements" do
            before do
                allow(user).to receive(:admin?).and_return(false)
                allow(user).to receive(:organization).and_return(organization)
                allow(organization).to receive(:approved?).and_return(false)
            end

            it "redirects to the dashboard" do
                expect(subject).to receive(:redirect_to).with(dashboard_path)
                subject.send(:verify_user)
            end
        end
    end
end
 