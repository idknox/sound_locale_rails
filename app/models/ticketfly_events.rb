require "open-uri"
require "json"
require "time"
require "net/http"

class TicketflyEvents

  def self.all
    new.all
  end

  def all
    url = get_url
    events = all_event_pages(url)
    venue_names = Venue.all.to_a.map { |venue| venue.name }

    events.map { |event| rename_columns(event) if event_venue_exists?(venue_names, event) }
  end

  private

  def get_url
    "http://www.ticketfly.com/api/events/list.json?orgId=1&" +
      "maxResults=200&city=Denver" +
      "&fromDate=#{Date.today.strftime("%Y-%m-%d")}" +
      "&fields=id,name,venue.name,headlinersName,startDate," +
      "ticketPurchaseUrl,ticketPrice,urlTwitter"
  end

  def all_event_pages(url)
    file = open(url) { |f| f.read }
    pages = JSON.parse(file)["totalPages"]
    events = []
    until pages == 0
      file = open(url+"&pageNum=#{pages}") { |f| f.read }
      events += JSON.parse(file)["events"]
      pages -= 1
    end
    events
  end

  def event_venue_exists?(venues, event)
    venues.include?(event["venue"]["name"])
  end

  def rename_columns(event)
    {
      :name => event["name"],
      :venue_id => Venue.find_by(:name => event["venue"]["name"]).id,
      :venue_name => event["venue"]["name"],
      :vendor_id => event["id"],
      :headliner => event["headlinersName"],
      :date => Date.parse(event["startDate"]).strftime("%Y-%m-%d"),
      :time => Time.parse(event["startDate"]).strftime("%H:%M:%S"),
      :tickets => event["ticketPurchaseUrl"],
      :url => event["ticketPurchaseUrl"],
      :twitter => event["urlTwitter"],
      :price => event["ticketPrice"]
    }
  end

end