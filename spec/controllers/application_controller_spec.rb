require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  before do
    allow(subject).to receive(:dashboard_path).and_return('/dashboard')
  end

  describe "after_sign_in_path_for" do
    it "redirects users to dashboard_path after sign-in" do
      user = instance_double(User)
      expect(subject.after_sign_in_path_for(user)).to eq("/dashboard")
    end
  end

  describe "authenticate_admin" do
    context "when user is an admin" do
      before do
        admin_user = instance_double(User, admin?: true)
        allow(subject).to receive(:current_user).and_return(admin_user)
      end

      it "allows access without redirection" do
        expect(subject).not_to receive(:redirect_to)
        subject.send(:authenticate_admin)
      end
    end

    context "when user is not an admin" do
      before do
        non_admin_user = instance_double(User, admin?: false)
        allow(subject).to receive(:current_user).and_return(non_admin_user)
      end

      it "redirects to dashboard with an access denied alert" do
        expect(subject).to receive(:redirect_to).with("/dashboard", alert: 'Access denied.')
        subject.send(:authenticate_admin)
      end
    end
  end
end
