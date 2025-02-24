require 'rails_helper'

RSpec.describe 'Creating a Ticket', type: :feature do

  before(:each) do
    @region = FactoryBot.create(:region)
    @resource = FactoryBot.create(:resource_category)
    @user = FactoryBot.create(:user)
    log_in_as(@user)
  end
  
  it 'can be created from the home screen' do
    visit(root_path)

    click_on('Get Help')

    fill_in('Full Name', with: 'Test Name')
    fill_in('Phone Number', with: '+1-555-123-4567')
    fill_in('Description', with: 'My Description')

    select(@region.name, from: 'Region')
    select(@resource.name, from: 'Resource Category')
    
    click_on('Send this help request')

    expect(current_path).to eq(ticket_submitted_path)
  end

  it 'cannot be created with an invalid phone number from the home screen' do
    visit(root_path)

    click_on('Get Help')

    fill_in('Full Name', with: 'Test Name')
    fill_in('Phone Number', with: '555-123-4567')
    fill_in('Description', with: 'My Description')

    select(@region.name, from: 'Region')
    select(@resource.name, from: 'Resource Category')
    
    click_on('Send this help request')

    expect(current_path).to eq(tickets_path)
  end

end
