class EventsController < ApplicationController
  def map
    @events = Event.where(:date => Date.today)
    respond_to do |format|
      format.html
      format.json { render :json => @events.to_json(:include => [:venue]) }
    end
  end

  def list
    @events = Event.where("date >= ?", Date.today).order(:date)
  end
end