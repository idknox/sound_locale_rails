class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def destroy_all
    Event.destroy_all
    flash[:notice] = "All events deleted"
    redirect_to root_path
  end
end
