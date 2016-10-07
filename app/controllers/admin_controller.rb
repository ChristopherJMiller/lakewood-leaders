class AdminController < ApplicationController
  respond_to :html
  before_filter :check_if_admin

  def check_if_admin
    if !(!session[:user_id].nil? && User.find_by_id(session[:user_id]).is_admin)
      head status: :forbidden and return
    end
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
