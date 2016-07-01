class SessionsController < ApplicationController

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password]) && user.verified
      session[:user_id] = user.id
      head status: :created
    else
      head status: :bad_request
    end
  end

  def destroy
    reset_session
    head status: :ok
  end
end
