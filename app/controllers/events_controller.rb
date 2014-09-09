class EventsController < ApplicationController
  def map

    date = params[:date] || Date.today

    @events = Event.where(:date => date)
    respond_to do |format|
      format.html
      format.json { render :json => @events.to_json(:include => [:venue]) }
    end
  end

  def list
    @events_by_date = Event.where("date >= ?", Date.today).order(:date).order(:venue_name).group_by { |event| event.date }
  end
end