class EventsController < ApplicationController
  def map

    @date = determine_date(params[:date])
    @events = Event.where(:date => @date).each {|event| event.time = event.time.strftime("%l:%M")}
    respond_to do |format|
      format.html
      format.json { render :json => @events.to_json(:include => [:venue]) }
    end
  end

  def list
    @events_by_date = future_events_grouped_by_date
  end

  private

  def determine_date(date)
    Date.tomorrow if date == "tomorrow"
    date || Date.today
  end

  def future_events_grouped_by_date
    Event.where("date >= ?", Date.today).order(:date).order(:venue_name).group_by { |event| event.date }
  end
end