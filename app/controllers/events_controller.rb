class EventsController < ApplicationController
  def map
    date = determine_date
    @events = Event.where(date: date)
    respond_to do |format|
      format.html
      format.json { render :json => @events.to_json(include: :venue) }
    end
  end

  def index
    s = Events::SongkickService.new.events
    s
  end

  def show
    event = Event.find(params[:id])
    render :json => event.to_json(include: :venue)
  end

  def more
    offset = params[:offset]
    limit = params[:limit]
    events = Event.where("date >= ?", Date.today).order(:date).limit(limit).offset(offset)
    render :json => events.to_json(include: :venue)
  end

  def by_date
    date = Date.parse(params[:date])
    events = Event.where("date = ?", date).order(:venue_name)
    render :json => events.to_json(include: :venue)
  end

  private

  def determine_date
    params[:date] == 'tomorrow' ? DateTime.now.tomorrow.to_date : params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def events_for_today
    Event.where('date = ?', Date.today).order(:venue_name)
    # events = params[:venue] ? Event.where("date >= ? AND venue_id = ?", Date.today, params[:venue]) : Event.where("date >= ?", Date.today)
    # events.order(:date).order(:venue_name).group_by { |event| event.date }
  end
end