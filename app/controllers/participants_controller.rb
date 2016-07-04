class ParticipantsController < ApplicationController
  respond_to :html, :json

  def index
    @participants = Event.find_by_id(params[:event_id]).participants.all
    respond_with @participants
  end

  def create
    if session[:user_id].nil? or params[:participant][:user_id] != session[:user_id].to_s
      head status: :forbidden and return
    end
    if !User.find_by_id(session[:user_id]).is_member
      head status: :forbidden and return
    end
    if Participant.find_by_event_id_and_user_id(params[:event_id], params[:participant][:user_id])
      head status: :conflict and return
    end
    participant = Participant.new(participant_parameters_create)
    if participant.save
      head status: :created, location: event_participant_path(participant.event, participant)
    else
      render json: {error: participant.errors}, status: :bad_request
    end
  end

  def destroy
    participant = Participant.find_by_event_id_and_id(params[:event_id], params[:id])
    if !participant
      head status: :not_found and return
    end
    if session[:user_id].nil? or (Participant.find_by_event_id_and_user_id(params[:event_id], session[:user_id]).nil? and !User.find_by_id(session[:user_id]).is_admin) or (!User.find_by_id(session[:user_id]).is_admin and !Participant.find_by_event_id_and_user_id(params[:event_id], session[:user_id]).user.is_member)
      head status: :forbidden and return
    end
    participant.destroy
    head status: :ok
  end

  private

  def participant_parameters_create
    parameters = params.require(:participant).permit(:user_id)
    parameters[:event_id] = params[:event_id]
    return parameters
  end
end
