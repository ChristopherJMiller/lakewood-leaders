# = Messages Controller
# Allows admins to send messages to users
class MessagesController < ApplicationController
  respond_to :html, :json

  def index
    return head status: :forbidden if session[:user_id].nil?
    return head status: :forbidden unless params[:user_id] == session[:user_id].to_s || User.find_by(id: session[:user_id]).admin?
    @messages = User.find_by(id: params[:user_id]).messages.all
    respond_with @messages
  end

  def new
    return head status: :forbidden unless !session[:user_id].nil? && User.find_by(id: session[:user_id]).admin?
    @message = Message.new
    respond_to :html
  end

  def show
    return head status: :forbidden if session[:user_id].nil?
    return head status: :forbidden unless params[:user_id] == session[:user_id].to_s || User.find_by(id: session[:user_id]).admin?
    @message = Message.find_by(user_id: params[:user_id], id: params[:id])
    if @message
      respond_with @message
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def create
    return head status: :forbidden if session[:user_id].nil? || !User.find_by(id: session[:user_id]).admin?
    message = Message.new(message_parameters_create)
    if message.save
      head status: :created, location: user_message_path(params[:user_id], message)
    else
      render json: {error: message.errors}, status: :bad_request
    end
  end

  def destroy
    return head status: :forbidden if session[:user_id].nil?
    return head status: :forbidden unless params[:user_id] == session[:user_id].to_s || User.find_by(id: session[:user_id]).admin?
    message = Message.find_by(id: params[:id])
    return head status: :not_found unless message
    message.destroy
    head status: :ok
  end

  private

  def message_parameters_create
    parameters = params.require(:message).permit(:subject, :body)
    parameters[:user_id] = params[:user_id]
    parameters
  end
end
