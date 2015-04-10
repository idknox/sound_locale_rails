require "open-uri"

class Kimono

  def self.events
    new.all
  end

  def all
    events = json_data["results"]["events"]
    venue = get_venue(json_data["name"])
    events[1..-1].map { |event| rename_columns(event, venue) }
  end


  def json_data
    url = "https://www.kimonolabs.com/api/duexnr82?apikey=#{ENV['KIMONO_KEY']}"
    file = open(url) { |f| f.read }
    JSON.parse(file)
  end

  def rename_columns(event, venue)
    event["date"] = Date.today.to_s if event["date"] == ""
    {
      name: event["name"]["text"],
      venue_id: venue.id,
      venue_name: venue.name,
      vendor_id: 0,
      headliner: event["name"]["text"].split("-")[0],
      date: Date.parse(event["date"]),
      time: "TBD",
      tickets: event["name"]["href"],
      url: "",
      twitter: "",
      price: event["price"]
    }
  end

  def get_venue(name)
    Venue.find_by(name: name)
  end
end
