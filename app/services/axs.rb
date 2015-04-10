require "open-uri"

class Axs

  def self.events
    new.all
  end

  def all
    url = get_url
    events = get_events(url)
    venue_names = Venue.all.to_a.map { |venue| venue.name }
    events.map { |event| rename_columns(event) if event_venue_exists?(venue_names, event) }
  end

  private

  def get_url
    "http://api.axs.com/v1/events?access_token=2EQYDNXR4TSZKBAG7859HC6PUVWJF3&" +
    "siteId=1&rows=500&lat=39.740009&long=-104.992302&radius=100"
  end

  def get_events(url)
    file = open(url) { |f| f.read }
    JSON.parse(file)["events"]
  end

  def event_venue_exists?(venues, event)
    venues.include?(event["venue"]["title"])
  end

  def rename_columns(event)
    {
      :name => event["title"]["eventTitleText"],
      :venue_id => Venue.find_by(:name => event["venue"]["title"]).id,
      :venue_name => event["venue"]["title"],
      :vendor_id => event["eventId"].to_i,
      :headliner => event["title"]["eventTitleText"],
      :opener => event["title"]["supportingText"],
      :date => Date.parse(event["eventDateTime"]),
      :time => Time.parse(event["eventDateTime"]),
      :tickets => event["ticketing"]["url"],
      :url => event["ticketing"]["eventUrl"],
      :twitter => "",
      :price => price_breakout(event)
    }
  end

  def price_breakout(ticket)
    "#{ticket['ticketPrice']} advance / #{ticket['doorPrice']} door"
  end
end