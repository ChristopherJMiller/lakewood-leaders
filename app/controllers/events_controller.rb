# = Events Controller
# Controller for Admin created events that users can join.
class EventsController < ApplicationController
  respond_to :html, :json

  def index
    @events = Event.all
    respond_with @events
  end

  def past
    @events = Event.where('finished = ?', true)
    respond_with @events
  end

  def show
    @event = Event.find_by(id: params[:id])
    if @event
      respond_with @event
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def new
    @event = Event.new
    respond_to :html
  end

  def edit
    @event = Event.find_by(id: params[:id])
    if @event
      respond_with @event
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def create
    return head status: :forbidden if session[:user_id].nil?
    return head status: :forbidden unless User.find_by(id: session[:user_id]).admin?
    event = Event.new(event_parameters_create)
    if event.save
      head status: :created, location: event_path(event)
    else
      render json: {error: event.errors}, status: :bad_request
    end
  end

  def update
    event = Event.find_by(id: params[:id])
    return head status: :not_found unless event
    if session[:user_id].nil? || !User.find_by(id: session[:user_id]).admin?
      return head status: :forbidden
    end
    if event.update(event_parameters_update)
      head status: :ok
    else
      render json: {error: event.errors}, status: :bad_request
    end
  end

  def destroy
    event = Event.find_by(id: params[:id])
    return head status: :not_found unless event
    if session[:user_id].nil? || !User.find_by(id: session[:user_id]).admin?
      return head status: :forbidden
    end
    event.destroy
    head status: :ok
  end

  private

  def event_parameters_create
    parameters = params.require(:event).permit(:name, :description, :location, :start_time, :end_time, :max_participants)
    parameters[:finished] = false
    parameters
  end

  def event_parameters_update
    params.require(:event).permit(:name, :description, :location, :start_time, :end_time, :finished, :max_participants)
  end
end
