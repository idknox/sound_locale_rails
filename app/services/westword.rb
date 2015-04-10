require "open-uri"

class Westword

  def self.events
    new.all
  end

  def all
    events = json_data["results"]["events"]
    venue_names = Venue.all.to_a.map { |venue| venue.name }
    events.map do |event|
      rename_columns(event) if event_venue_exists?(venue_names, event)
    end
  end


  def json_data
    url = "https://www.kimonolabs.com/api/9m6nuh4o?apikey=fz3XwucxUth2sbjeGOF2afAwlaM0DZnV"
    file = open(url) { |f| f.read }
    JSON.parse(file)
  end

  def rename_columns(event)
    # time = event["venue_date"]["text"].split("\n")[1].split(" ").length > 0 ? Time.parse(event["venue_date"]["text"].split("\n")[1].split(" ")[0] + event["venue_date"]["text"].split("\n")[1].split(" ")[0]) : "TBD"
  {
      :name => event["name"]["text"],
      :venue_id => Venue.find_by(:name => event["venue_date"]["text"].split(" :")[0]).id,
      :venue_name => event["venue_date"]["text"].split(" :")[0],
      :vendor_id => 0,
      :headliner => event["name"]["text"],
      :date => "",
      :time => "",
      :tickets => event["name"]["href"],
      :url => "",
      :twitter => "",
      :price => ""
    }
  end

  def venue_name
    json_data["name"]
  end

  def event_venue_exists?(venues, event)
    venues.include?(event["venue_date"]["text"].split(" :")[0])
  end
end
