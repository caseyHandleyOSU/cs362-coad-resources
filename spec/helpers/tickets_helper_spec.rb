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
    describe 'format_phone_number' do
        it 'formats a 10-digit US phone number correctly' do
            expect(helper.format_phone_number('5031234567')).to eq('+15031234567')
        end

        it 'formats a US phone number with country code' do
            expect(helper.format_phone_number('+1 503-123-4567')).to eq('+15031234567')
        end

        it 'removes non-numeric characters' do
            expect(helper.format_phone_number('(503) 123-4567')).to eq('+15031234567')
        end

        it 'returns nil for an empty string' do
            expect(helper.format_phone_number('')).to be_nil
        end

        it 'returns nil for nil input' do
            expect(helper.format_phone_number(nil)).to be_nil
        end
    end
end
