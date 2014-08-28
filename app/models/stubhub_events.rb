require "open-uri"
require "json"
require "time"
require "net/http"

class StubhubEvents

  def self.all
    new.all
  end

  def all
    url = get_url
    events = get_events(url)
    venue_names = Venue.all.to_a.map { |venue| venue.name }

    events.map do |event|
      if event_venue_exists?(venue_names, event)
        rename_columns(event)
      end
    end
  end

  private

  def get_url
    "http://www.stubhub.com/listingCatalog/select?" +
      "q=stubhubDocumentType:event%20AND%20state:%22CO%22%20AND%20" +
      "nickname:concert~&wt=json&indent=on&fl=name_secondary%20" +
      "venue_name%20id%20date_confirm"
  end

  def get_events(url)
    file = open(url) { |f| f.read }
    JSON.parse(file)["response"]["docs"]
  end

  def event_venue_exists?(venues, event)
    venues.include?(event["venue_name"])
  end

  def rename_columns(event)
    {
      "name" => event["name_secondary"],
      "venue_id" => Venue.find_by(:name => event["venue_name"]).id,
      "venue_name" => event["venue_name"],
      "vendor_id" => event["id"].to_i,
      "headliner" => event["name_secondary"],
      "date" => Date.parse(event["date_confirm"]).strftime("%Y-%m-%d"),
      "time" => Time.parse(event["date_confirm"]).strftime("%H:%M:%S"),
      "tickets" => "",
      "url" => "",
      "twitter" => "",
      "price" => ""
    }
  end
end