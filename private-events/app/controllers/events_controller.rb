class EventsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def new
    @event = current_user.created_events.new
  end

  def create
    @event = current_user.created_events.build(event_params)
    if @event.save
      flash[:success] = "Event created."
      redirect_to event_path(@event)
    else
      flash.now[:danger] = "Error creating event. Please try again."
      render 'new'
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def index
    @events = Event.all
  end


  private

    def event_params
      params.require(:event).permit(:date, :location, :description)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "You need to be logged in"
        redirect_to login_path
      end
    end
end
