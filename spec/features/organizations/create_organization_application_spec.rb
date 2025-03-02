require 'rails_helper'

RSpec.describe 'Creating an Organization Application', type: :feature do

  before(:each) do
    @cat = FactoryBot.create(:resource_category)

    @user = FactoryBot.create(:user)
    @org = FactoryBot.build(:organization)
    log_in_as(@user)

    allow_any_instance_of(UserMailer).
      to receive(:mail).
      and_return(nil)
  end

  it 'creates an organization' do
    visit(dashboard_path)

    click_on('Create Application')

    choose('organization[agreement_one]')
    choose('organization[agreement_two]')
    choose('organization[agreement_three]')
    choose('organization[agreement_four]')
    choose('organization[agreement_five]')
    choose('organization[agreement_six]')
    choose('organization[agreement_seven]')
    choose('organization[agreement_eight]')

    fill_in('organization[primary_name]', with: @org.primary_name)
    fill_in('organization[name]', with: @org.name)
    fill_in('organization[title]', with: @org.title)
    fill_in('organization[phone]', with: @org.phone)
    fill_in('organization[secondary_name]', with: @org.secondary_name)
    fill_in('organization[secondary_phone]', with: @org.secondary_phone)
    fill_in('organization[email]', with: @org.email)

    fill_in('organization[description]', with: @org.description)

    click_on('Apply')

    expect(current_path).to eq(organization_application_submitted_path)
  end

end
