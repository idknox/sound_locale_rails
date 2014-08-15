class EventsController < ApplicationController
  def index

    @events = Event.where(:date_time => Date.today.strftime("%Y-%m-%d %H:%M:%S %z"))
    puts "*" * 80
    # puts Event.where(:venue_name => "Beauty Bar Denver").first.date_time
    puts Date.today.strftime("%Y-%m-%d %H:%M:%S")
    puts "*" * 80
  end

  def list
    @events = Event.all
  end

  def destroy_all
    Event.destroy_all
    flash[:notice] = "All events deleted"
    redirect_to root_path
  end
end
