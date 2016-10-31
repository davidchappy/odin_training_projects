class AttendencesController < ApplicationController
  def create
    user = User.find(current_user.id)
    event = Event.find(params[:id])
    Attendence.create(attendee_id: user.id, attended_event_id: event.id)
    flash.now[:success] = "#{user.name} will be attending #{event.location}"
    redirect_to events_path
  end
end
