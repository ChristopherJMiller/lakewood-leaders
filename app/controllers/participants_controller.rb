# = Participant Controller
# Allows users to join events
class ParticipantsController < ApplicationController
  respond_to :html, :json

  def index
    @participants = Event.find_by(id: params[:event_id]).participants.all
    respond_with @participants
  end

  def create
    return head status: :forbidden if session[:user_id].nil? || params[:participant][:user_id] != session[:user_id].to_s
    return head status: :forbidden unless User.find_by(id: session[:user_id]).member?
    return head status: :conflict if Participant.find_by(event_id: params[:event_id], user_id: params[:participant][:user_id])
    participant = Participant.new(participant_parameters_create)
    if participant.save
      head status: :created, location: event_participant_path(participant.event, participant)
    else
      render json: {error: participant.errors}, status: :bad_request
    end
  end

  def destroy
    participant = Participant.find_by(event_id: params[:event_id], id: params[:id])
    return head status: :not_found unless participant
    if session[:user_id].nil? || (Participant.find_by(event_id: params[:event_id], user_id: session[:user_id]).nil? && !User.find_by(id: session[:user_id]).admin?) || (!User.find_by(id: session[:user_id]).admin? && !Participant.find_by(event_id: params[:event_id], user_id: session[:user_id]).user.member?)
      return head status: :forbidden
    end
    participant.destroy
    head status: :ok
  end

  private

  def participant_parameters_create
    parameters = params.require(:participant).permit(:user_id)
    parameters[:event_id] = params[:event_id]
    parameters
  end
end
