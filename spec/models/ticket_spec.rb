require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:region) { create(:region) }
  let(:resource_category) { create(:resource_category) }
  let(:organization) { create(:organization) } 

  describe "methods" do
    it "returns the name as string representation" do
      ticket = create(:ticket, id: 123)
      expect(ticket.to_s).to eq('Ticket 123')
    end

    describe 'open?' do
      it 'returns true if ticket is open' do
        ticket = create(:ticket, closed: false)
        expect(ticket.open?).to be(true)
      end

      it 'returns false if ticket is closed' do
        ticket = create(:ticket, closed: true)
        expect(ticket.open?).to be(false)
      end
    end

    describe 'captured?' do
      it 'returns true if the ticket is assigned to an organization' do
        ticket = create(:ticket, organization: organization)
        expect(ticket.captured?).to be(true)
      end

      it 'returns false if the ticket is not assigned an organization' do
        ticket = create(:ticket, organization: nil)
        expect(ticket.captured?).to be(false)
      end
    end
  end

  describe "associations" do
    it { should belong_to(:region) }
    it { should belong_to(:resource_category) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:region_id) }
    it { should validate_presence_of(:resource_category_id) }

    it { should validate_length_of(:name).is_at_least(1).is_at_most(255).on(:create) }
    it { should validate_length_of(:description).is_at_most(1020) }
  end

  describe "scopes" do
    let!(:open_ticket) { create(:ticket, name: 'Open Ticket', closed: false, organization: nil, region: region, resource_category: resource_category) }
    let!(:closed_ticket) { create(:ticket, name: 'Closed Ticket', closed: true, region: region, resource_category: resource_category) }
    let!(:assigned_ticket) { create(:ticket, name: 'Assigned Ticket', closed: false, organization: organization, region: region, resource_category: resource_category) }

    it 'returns open tickets' do
      expect(Ticket.open).to include(open_ticket)
      expect(Ticket.open).not_to include(closed_ticket, assigned_ticket)
    end

    it 'returns closed tickets' do
      expect(Ticket.closed).to include(closed_ticket)
      expect(Ticket.closed).not_to include(open_ticket, assigned_ticket)
    end

    it 'returns all assigned tickets' do
      expect(Ticket.all_organization).to include(assigned_ticket)
      expect(Ticket.all_organization).not_to include(open_ticket, closed_ticket)
    end

    it 'returns tickets for a specific organization' do
      expect(Ticket.organization(organization.id)).to include(assigned_ticket)
      expect(Ticket.organization(organization.id)).not_to include(open_ticket, closed_ticket)
    end

    it 'returns closed tickets for a specific organization' do
      closed_org_ticket = create(:ticket, closed: true, organization: organization)
      expect(Ticket.closed_organization(organization.id)).to include(closed_org_ticket)
      expect(Ticket.closed_organization(organization.id)).not_to include(open_ticket, closed_ticket, assigned_ticket)
    end

    it 'returns tickets for a specific region' do
      expect(Ticket.region(region.id)).to include(open_ticket, closed_ticket, assigned_ticket)
    end

    it 'returns tickets for a specific resource category' do
      expect(Ticket.resource_category(resource_category.id)).to include(open_ticket, closed_ticket, assigned_ticket)
    end
  end
end