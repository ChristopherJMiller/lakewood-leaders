class MessagesController < ApplicationController
  respond_to :html, :json

  def index
    if session[:user_id].nil?
      head status: :forbidden and return
    end
    if params[:user_id] == session[:user_id].to_s or User.find_by_id(session[:user_id]).is_admin
      @messages = User.find_by_id(params[:user_id]).messages.all
      respond_with @messages
    else
      head status: :forbidden and return
    end
  end

  def new
    if !session[:user_id].nil? and User.find_by_id(session[:user_id]).is_admin
      @message = Message.new
      respond_to :html
    else
      head status: :forbidden and return
    end
  end

  def show
    if session[:user_id].nil?
      head status: :forbidden and return
    end
    if params[:user_id] == session[:user_id].to_s or User.find_by_id(session[:user_id]).is_admin
      @message = Message.find_by_user_id_and_id(params[:user_id], params[:id])
      if @message
        respond_with @message
      else
        respond_to do |format|
          format.html { not_found }
          format.json { head status: :not_found }
        end
      end
    else
      head status: :forbidden and return
    end
  end

  def create
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    message = Message.new(message_parameters_create)
    if message.save
      head status: :created, location: user_message_path(params[:user_id], message)
    else
      render json: {error: message.errors}, status: :bad_request
    end
  end

  def destroy
    if session[:user_id].nil?
      head status: :forbidden and return
    end
    if params[:user_id] == session[:user_id].to_s or User.find_by_id(session[:user_id]).is_admin
      message = Message.find_by_id(params[:id])
      if !message
        head status: :not_found and return
      end
      message.destroy
      head status: :ok
    else
      head status: :forbidden and return
    end
  end

  private

  def message_parameters_create
    params.require(:message).permit(:user_id, :subject, :body)
  end
end
