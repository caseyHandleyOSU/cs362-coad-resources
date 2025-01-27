require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  BASE_TITLE = 'Disaster Resource Network'

  describe "tests application" do

    it "full title" do

      expect(helper.full_title).to eq(BASE_TITLE)
      test_title = "Hello, World"
      expect(helper.full_title(test_title)).to eq("#{test_title} | #{BASE_TITLE}")

    end
    
  end

end
