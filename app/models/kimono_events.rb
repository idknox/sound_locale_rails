require "open-uri"

class KimonoEvents

  def self.all
    new.all
  end

  def all
    events = json_data["results"]["events"]
    events[1..-1].map { |event| rename_columns(event) }
  end


  def json_data
    url = "https://www.kimonolabs.com/api/duexnr82?apikey=fz3XwucxUth2sbjeGOF2afAwlaM0DZnV"
    file = open(url) { |f| f.read }
    JSON.parse(file)
  end

  def rename_columns(event)
    event["date"] = Date.today.to_s if event["date"] == ""
    {
      name: event["name"]["text"],
      venue_id: Venue.find_by(name: venue_name).id,
      venue_name: venue_name,
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

  def venue_name
    json_data["name"]
  end
end
