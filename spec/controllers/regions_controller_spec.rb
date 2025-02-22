require 'rails_helper'

RSpec.describe RegionsController, type: :controller do
    let(:user) { instance_double(User, admin?: true)}
    let(:region) { instance_double(Region, id: 1, name: 'Test Region')}

    before do
        allow(controller).to receive(:authenticate_user!)
        allow(controller).to receive(:authenticate_admin)
        allow(controller).to receive(:current_user).and_return(user)
        allow(Region).to receive(:find).with(1).and_return(region)
    end
    
    describe 'index' do
        let(:regions_mock) { double("Regions") }

        before do
            allow(Region).to receive(:all).and_return(regions_mock)
        end

        it 'fetches all regions' do
            subject.index
            expect(Region).to have_received(:all)
        end
    end

    describe 'show' do
        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({ id: 1 }))
            allow(Region).to receive(:includes).with(:tickets).and_return(Region)
            allow(Region).to receive(:find).with(1).and_return(region)
        end

        it 'fetches the region with tickets' do
            subject.show
            expect(Region).to have_received(:includes).with(:tickets)
            expect(Region).to have_received(:find).with(1)
        end
    end

    describe 'new' do
        before do
            allow(Region).to receive(:new).and_return(region)
        end

        it 'initializes a new region' do
            subject.new
            expect(Region).to have_received(:new)
            expect(subject.instance_variable_get(:@region)).to eq(region)
        end
    end

    describe 'create' do
        let(:new_region) { instance_double(Region, save: true) }

        before do
            allow(Region).to receive(:new).and_return(new_region)
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({ region: { name: "New Region" } }))
        end

        context 'when the region is successfully created' do
            before do
                allow(new_region).to receive(:save).and_return(true)
            end

            it 'redirects to the index with a success message' do
                expect(subject).to receive(:redirect_to).with(regions_path, notice: 'Region successfully created.')
                subject.create
            end
        end

        context 'when the region creation fails' do
            before do
                allow(new_region).to receive(:save).and_return(false)
            end

            it 'renders the new template' do
                expect(subject).to receive(:render).with(:new)
                subject.create
            end
        end
    end

    describe 'edit' do
        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({ id: 1 }))
        end

        it 'sets region' do
            subject.edit
            expect(subject.instance_variable_get(:@region)).to eq(region)
        end
    end

    describe 'update' do
        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({ id: 1, region: { name: "Updated Region" } }))
            allow(region).to receive(:update).and_return(true)
        end

        context 'when the update is successful' do
            it 'redirects to the region with a success message' do
                expect(subject).to receive(:redirect_to).with(region, notice: 'Region successfully updated.')
                subject.update
            end
        end

        context 'when the update fails' do
            before do
                allow(region).to receive(:update).and_return(false)
            end

            it 'renders the edit template' do
                expect(subject).to receive(:render).with(:edit)
                subject.update
            end
        end
    end

    describe 'destroy' do
        let(:delete_service) { instance_double(DeleteRegionService, run!: true) }

        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({ id: 1 }))
            allow(Region).to receive(:includes).with(:tickets).and_return(Region)
            allow(Region).to receive(:find).with(1).and_return(region)
            allow(DeleteRegionService).to receive(:new).with(region).and_return(delete_service)
        end

        it 'runs the delete service and redirects with a success message' do
            expect(delete_service).to receive(:run!)
            expect(subject).to receive(:redirect_to).with(regions_path, notice: "Region #{region.name} was deleted. Associated tickets now belong to the 'Unspecified' region.")
            subject.destroy
        end
    end
end

