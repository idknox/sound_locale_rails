require "open-uri"
require "json"
require "date"
require "net/http"

class JsonEvents

  def initialize
  end

  def get_tf
    events = []
    url = "http://www.ticketfly.com/api/events/list.json?orgId=1&" +
      "maxResults=200&city=Denver" +
      "&fromDate=#{Date.today.strftime("%Y-%m-%d")}" +
      "&fields=id,name,venue.name,headlinersName,startDate," +
      "ticketPurchaseUrl,ticketPrice,urlTwitter"

    file = open(url) { |f| f.read }
    page = JSON.parse(file)["totalPages"]

    until page == 0
      file = open(url+"&pageNum=#{page}") { |f| f.read }
      events += JSON.parse(file)["events"]
      page -= 1
    end
    events.map { |event| rename_tf(event) }
  end

  def get_sh
    url = "http://www.stubhub.com/listingCatalog/select?" +
      "q=stubhubDocumentType:event%20AND%20state:%22CO%22%20AND%20" +
      "nickname:concert~&wt=json&indent=on&fl=name_secondary%20" +
      "venue_name%20id%20date_confirm"

    file = open(url) { |f| f.read }
    events = JSON.parse(file)["response"]["docs"]
    events.map { |event| rename_sh(event) }
  end

  def rename_tf(event)
    {
      "name" => event["name"],
      "venue" => event["venue"]["name"],
      "vendor_id" => event["id"],
      # "image" => event["image"]["xlarge"]["path"],
      "headliner" => event["headlinersName"],
      "date" => Date.parse(event["startDate"]),
      "tickets" => event["ticketPurchaseUrl"],
      "url" => event["ticketPurchaseUrl"],
      "twitter" => event["urlTwitter"],
      "price" => event["ticketPrice"]
    }
  end

  def rename_sh(event)
    {
      "name" => event["name_secondary"],
      "venue" => event["venue_name"],
      "vendor_id" => event["id"].to_i,
      # "image" => event["image"]["xlarge"]["path"],
      "headliner" => event["name_secondary"],
      "date" => Date.parse(event["date_confirm"]),
      "tickets" => "",
      "url" => "",
      "twitter" => "",
      "price" => ""
    }
  end
end
