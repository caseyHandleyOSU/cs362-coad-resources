require 'rails_helper'

RSpec.describe ResourceCategoriesController, type: :controller do
    let(:user) { instance_double(User, admin?: true) }
    let(:resource_category) { instance_double(ResourceCategory, id: 1, name: "Test Category") }

    before do
        allow(controller).to receive(:authenticate_user!)
        allow(controller).to receive(:authenticate_admin)
        allow(controller).to receive(:current_user).and_return(user)
        allow(ResourceCategory).to receive(:find).with(1).and_return(resource_category)
    end

    describe 'index' do
        let(:categories_mock) { double("ResourceCategories") }

        before do
            allow(ResourceCategory).to receive(:all).and_return(categories_mock)
            allow(categories_mock).to receive(:order).with(:name).and_return(categories_mock)
        end

        it 'fetches all resource categories ordered by name' do
            subject.index
            expect(ResourceCategory).to have_received(:all)
            expect(categories_mock).to have_received(:order).with(:name)
        end
    end

    describe 'new' do
        before do
            allow(ResourceCategory).to receive(:new).and_return(resource_category)
        end

        it 'initializes a new resource category' do
            subject.new
            expect(ResourceCategory).to have_received(:new)
            expect(subject.instance_variable_get(:@resource_category)).to eq(resource_category)
        end
    end

    describe 'create' do
        let(:new_resource_category) { instance_double(ResourceCategory, save: true) }

        before do
            allow(ResourceCategory).to receive(:new).and_return(new_resource_category)
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({ resource_category: { name: "New Category" } }))
        end

        context 'when the resource category is successfully created' do
            before do
                allow(new_resource_category).to receive(:save).and_return(true)
            end

            it 'redirects to the index with a success message' do
                expect(subject).to receive(:redirect_to).with(resource_categories_path, notice: 'Category successfully created.')
                subject.create
            end
        end

        context 'when the resource category creation fails' do
            before do
                allow(new_resource_category).to receive(:save).and_return(false)
            end

            it 'renders the new template' do
                expect(subject).to receive(:render).with(:new)
                subject.create
            end
        end
    end

    describe 'update' do
        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({ id: 1, resource_category: { name: "Updated Category" } }))
            allow(ResourceCategory).to receive(:find).with(1).and_return(resource_category)
        end

        context 'when the update is successful' do
            before do
                allow(resource_category).to receive(:update).and_return(true)
            end

            it 'redirects to the resource category with a success message' do
                expect(subject).to receive(:redirect_to).with(resource_category, notice: 'Category successfully updated.')
                subject.send(:set_resource_category)
                subject.update
                expect(resource_category).to have_received(:update).with({ "name" => "Updated Category" })
            end
        end

        context 'when the update fails' do
            before do
                allow(resource_category).to receive(:update).and_return(false)
            end

            it 'renders the edit template' do
                expect(subject).to receive(:render).with(:edit)
                subject.send(:set_resource_category)
                subject.update
                expect(resource_category).to have_received(:update).with({ "name" => "Updated Category" })
            end
        end
    end

    describe 'activate' do
        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({ id: "1" }))
            allow(ResourceCategory).to receive(:find).with("1").and_return(resource_category)
        end
        
        context 'when activation is successful' do
            before do
                allow(resource_category).to receive(:activate).and_return(true)
            end

            it 'redirects with a success message' do
                expect(subject).to receive(:redirect_to).with(resource_category, notice: 'Category activated.')
                subject.send(:set_resource_category)
                subject.activate
            end
        end

        context 'when activation fails' do
            before do
                allow(resource_category).to receive(:activate).and_return(false)
            end

            it 'redirects with an alert message' do
                expect(subject).to receive(:redirect_to).with(resource_category, alert: 'There was a problem activating the category.')
                subject.send(:set_resource_category)
                subject.activate
            end
        end
    end

    describe 'deactivate' do
        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({ id: "1" }))
            allow(ResourceCategory).to receive(:find).with("1").and_return(resource_category)
        end
        context 'when deactivation is successful' do
            before do
                allow(resource_category).to receive(:deactivate).and_return(true)
            end

            it 'redirects with a success message' do
                expect(subject).to receive(:redirect_to).with(resource_category, notice: 'Category deactivated.')
                subject.send(:set_resource_category)
                subject.deactivate
            end
        end

        context 'when deactivation fails' do
            before do
                allow(resource_category).to receive(:deactivate).and_return(false)
            end

            it 'redirects with an alert message' do
                expect(subject).to receive(:redirect_to).with(resource_category, alert: 'There was a problem deactivating the category.')
                subject.send(:set_resource_category)
                subject.deactivate
            end
        end
    end

    describe 'destroy' do
        let(:delete_service) { instance_double(DeleteResourceCategoryService, run!: true) }

        before do
            allow(controller).to receive(:params).and_return(ActionController::Parameters.new({ id: "1" }))
            allow(ResourceCategory).to receive(:find).with("1").and_return(resource_category)
            allow(DeleteResourceCategoryService).to receive(:new).with(resource_category).and_return(delete_service)
        end

        it 'runs the delete service and redirects with a success message' do
            expect(delete_service).to receive(:run!)
            expect(subject).to receive(:redirect_to).with(resource_categories_path, notice: "Category #{resource_category.name} was deleted.\nAssociated tickets now belong to the 'Unspecified' category.")
            subject.send(:set_resource_category)
            subject.destroy
        end
    end
end
