require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TIcketsHelper. For example:
#
# describe TIcketsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TicketsHelper, type: :helper do

  describe "test tickets helper" do
    
    it "format phone number" do

      number = "555-111-2222"
      expect(helper.format_phone_number(number)).to eq("+15551112222")
      expect{helper.format_phone_number()}.to raise_error(ArgumentError)
      expect(helper.format_phone_number("4")).to eq("+14")

    end

  end

end
