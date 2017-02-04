# = User Controller
class UsersController < ApplicationController
  respond_to :html, :json

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = User.find_by(id: params[:id])
    return head status: :not_found unless @user
    respond_with @user
  end

  def new
    @user = User.new
    respond_to :html
  end

  def edit
    @user = User.find_by(id: params[:id])
    if @user
      return head status: :forbidden unless @user.id == session[:user_id]
      respond_with @user
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def create
    user = User.new(user_parameters_create)

    if verify_recaptcha(model: user) && user.save
      head status: :created
    else
      render json: {error: user.errors}, status: :bad_request
    end
  end

  def update
    user = User.find_by(id: params[:id])
    return head status: :not_found unless user
    if (session[:user_id].nil? || user.id != session[:user_id]) && (User.find_by(id: session[:user_id]).nil? || User.find_by(id: session[:user_id]).rank < 2)
      return head status: :forbidden
    end
    if user.update(user_parameters_update)
      head status: :ok
    else
      render json: {error: user.errors}, status: :bad_request
    end
  end

  def change_password
    user = User.find_by(id: params[:user_id])
    return head status: :not_found unless user
    return head status: :forbidden if user.id != session[:user_id] || session[:user_id].nil?
    if user.update(user_parameters_change_password)
      head status: :ok
    else
      render json: {error: user.errors}, status: :bad_request
    end
  end

  def verify_email
    user = User.find_by(verify_token: params[:token])
    if user
      user.update_attribute(:verified, true)
      respond_to :html
    else
      head status: :bad_request
    end
  end

  def verify_parent_email
    user = User.find_by(parent_verify_token: params[:token])
    if user
      user.update_attribute(:parent_verified, true)
      respond_to :html
    else
      head status: :bad_request
    end
  end

  private

  def user_parameters_create
    parameters = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    if params[:user][:parent_email].blank?
      parameters[:parent_email] = nil
    else
      parameters[:parent_email] = params[:user][:parent_email]
    end
    parameters[:parent_verified] = false
    parameters[:verified] = false
    parameters[:rank] = 0
    parameters
  end

  def user_parameters_update
    params.require(:user).permit(:name, :rank)
  end

  def user_parameters_change_password
    params.require(:user).permit(:password, :password_confirmation)
  end
end
