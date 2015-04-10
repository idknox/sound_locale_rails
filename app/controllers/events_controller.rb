class EventsController < ApplicationController
  def map
    date = determine_date
    @events = Event.where(date: date)
    respond_to do |format|
      format.html
      format.json { render :json => @events.to_json(:include => :venue) }
    end
  end

  def index
    @events_by_date = future_events_grouped_by_date
  end

  private

  def determine_date
    params[:date] ||= params[:date] == "tomorrow" ? Date.tomorrow : Date.today
  end

  def future_events_grouped_by_date
    events = params[:venue] ? Event.where("date >= ? AND venue_id = ?", Date.today, params[:venue]) : Event.where("date >= ?", Date.today)
    events.order(:date).order(:venue_name).group_by { |event| event.date }
  end
end