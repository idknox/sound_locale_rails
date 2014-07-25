require "open-uri"
require "json"
require "date"

class JsonEvents

  def initialize
  end

  def get_tf
    events = []
    url = "http://www.ticketfly.com/api/events/list.json?orgId=1&" +
      "maxResults=200&city=Denver" +
      "&fromDate=#{Date.today.strftime("%Y-%m-%d")}" +
      "&fields=name,venue.name,headlinersName,startDate," +
      "ticketPurchaseUrl,ticketPrice,urlTwitter,urlFacebook"

    file = open(url) { |f| f.read }
    page = JSON.parse(file)["totalPages"]

    until page == 0
      file = open(url+"&pageNum=#{page}") { |f| f.read }
      events += JSON.parse(file)["events"]
      page -= 1
    end
    events
  end
end