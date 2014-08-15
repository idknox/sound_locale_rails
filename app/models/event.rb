require "open-uri"
require "json"
require "time"
require "net/http"

class Event < ActiveRecord::Base
  belongs_to :venue

  validates :vendor_id, :uniqueness => true

  def self.get_ticketfly_events
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
    events.map { |event| rename_tf_columns(event) }
  end

  def self.get_stubhub_events
    url = "http://www.stubhub.com/listingCatalog/select?" +
      "q=stubhubDocumentType:event%20AND%20state:%22CO%22%20AND%20" +
      "nickname:concert~&wt=json&indent=on&fl=name_secondary%20" +
      "venue_name%20id%20date_confirm"

    file = open(url) { |f| f.read }
    events = JSON.parse(file)["response"]["docs"]
    events.map { |event| rename_sh_columns(event) }
  end

  private

  def self.rename_tf_columns(event)

    if Venue.find_by(:name => event["venue"]["name"]) == nil
      puts "*" * 80
      p event
      puts "*" * 80

    end
    {
      "name" => event["name"],
      "venue_id" => Venue.find_by(:name => event["venue"]["name"]).id,
      "venue_name" => event["venue"]["name"],
      "vendor_id" => event["id"],
      # "image" => event["image"]["xlarge"]["path"],
      "headliner" => event["headlinersName"],
      "date_time" => event["startDate"],
      "tickets" => event["ticketPurchaseUrl"],
      "url" => event["ticketPurchaseUrl"],
      "twitter" => event["urlTwitter"],
      "price" => event["ticketPrice"]
    }
  end

  def self.rename_sh_columns(event)
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
