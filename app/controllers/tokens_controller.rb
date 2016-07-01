class TokensController < ApplicationController
  respond_to :json

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password]) && user.verified
      token = SecureRandom.uuid
      Token.create(token: token, user_id: user.id)
      render json: {token: token}, status: :created
    else
      head status: :bad_request
    end
  end
end
