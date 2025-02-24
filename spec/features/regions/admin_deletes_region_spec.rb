require 'rails_helper'

RSpec.describe 'Deleting a Region', type: :feature do

  before(:each) do
    @region = FactoryBot.create(:region)
    @user = FactoryBot.create(:user, :admin)
    log_in_as(@user)
  end

  it 'deletes an existing region successfully' do
    visit(regions_path)

    click_on(@region.name)
    expect(current_path).to eq(region_path(@region.id))
    click_on('Delete')

    expect(current_path).to eq(regions_path)
  end

end
