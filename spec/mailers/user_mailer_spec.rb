require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
    describe "new_organization_application" do
        let(:recipient) { "test@example.com" }
        let(:organization) { instance_double("Organization", name: "Test Org", primary_name: "John Doe") }

        context "when in production or test environment" do
            before do
                allow(Rails.env).to receive(:production?).and_return(true)
                allow(Rails.env).to receive(:test?).and_return(true) 
            end

            it "sends an email with the correct subject and recipient" do
                mail = UserMailer.with(to: recipient, new_organization: organization).new_organization_application
                expect(mail.to).to eq([recipient])
                expect(mail.subject).to eq("New Organization Application Pending")
                expect(mail.from).to eq(["co.coad.dev@gmail.com"])
                expect(mail.body.encoded).to include("John Doe")
                expect(mail.body.encoded).to include("Test Org")
            end
        end
    end
end
