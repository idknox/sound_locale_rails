class EventsController < ApplicationController
  def index

    @events = Event.where(:date => Date.today)

    respond_to do |format|
      format.html
      format.json { render :json => @events.to_json(:include => [:venue])}
    end
  end

  def list
    @events = Event.all.order(:date)

  end

  def destroy_all
    Event.destroy_all
    flash[:notice] = "All events deleted"
    redirect_to root_path
  end
end
