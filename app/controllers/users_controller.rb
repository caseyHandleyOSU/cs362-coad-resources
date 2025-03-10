class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin

  def all_emails
    @users = User.all.order(:email)
  end

end
