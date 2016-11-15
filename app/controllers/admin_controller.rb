# = Admin Controller
# Manages whether the requested user is an admin or not and deny them or grant them access accordingly.
class AdminController < ApplicationController
  respond_to :html
  before_action :check_if_admin

  def check_if_admin
    return head status: :forbidden unless !session[:user_id].nil? && User.find_by(id: session[:user_id]).admin?
  end

  def users
    @users = User.all
    respond_with @users
  end

  def events
    @events = Event.all
    respond_with @events
  end
end
