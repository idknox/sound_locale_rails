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
    @events = {list_events: future_events_grouped_by_date, grid_events: Event.where("date >= ?", Date.today).order(:date).limit(50)}
  end

  def more
    offset = params[:offset]
    events = Event.where("date >= ?", Date.today).order(:date).limit(55).offset(offset)
    render :json => events.to_json(:include => :venue)
  end

  private

  def determine_date
    params[:date] == 'tomorrow' ? DateTime.now.tomorrow.to_date : params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def future_events_grouped_by_date
    events = params[:venue] ? Event.where("date >= ? AND venue_id = ?", Date.today, params[:venue]) : Event.where("date >= ?", Date.today)
    events.order(:date).order(:venue_name).group_by { |event| event.date }
  end
end