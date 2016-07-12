class SessionsController < ApplicationController

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password]) && user.verified
      session[:user_id] = user.id
      head status: :created
    else
      if !user.verified
        user.errors.add(:email, "This user is not verified, please check your email.")
      end
      if !user.authenticate(params[:password]) || !user
        user.errors.add(:password, "Invalid email and password combination")
      end
      render json: {error: user.errors}, status: :bad_request
    end
  end

  def destroy
    reset_session
    head status: :ok
  end
end
