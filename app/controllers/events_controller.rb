class EventsController < ApplicationController
  def index
    @events = Event.where(:venue_name => Venue.find(1).name)
    @venue = Venue.find(1)
    @user = User.new
  end

  def destroy_all
    Event.destroy_all
    flash[:notice] = "All events deleted"
    redirect_to root_path
  end
end
