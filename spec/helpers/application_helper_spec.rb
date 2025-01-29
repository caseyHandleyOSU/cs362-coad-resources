require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
    describe "full_title" do
        let(:base_title) { "Disaster Resource Network" }

        it "returns the base title when no page title is provided" do
        expect(helper.full_title).to eq(base_title)
        end

        it "returns the page title followed by the base title when a page title is provided" do
        expect(helper.full_title("Dashboard")).to eq("Dashboard | #{base_title}")
        end

        it "handles titles with multiple words correctly" do
        expect(helper.full_title("User Profile")).to eq("User Profile | #{base_title}")
        end
    end

end
