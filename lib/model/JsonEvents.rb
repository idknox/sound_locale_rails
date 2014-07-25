require "open-uri"
require "JSON"

class JsonEvents

  def initialize
  end

  def get_tf
    file = open(
      "http://www.ticketfly.com/api/events/list.json?orgId=1&" +
        "maxResults=250" +
        "&city=Denver" +
        "&fromDate=2014-07-29" +
        "&fields=name,venue.name,headlinersName,startDate," +
        "ticketPurchaseUrl,ticketPrice,urlTwitter,urlFacebook"
    ) { |f| f.read }
    locals = JSON.parse(file)
    locals["events"]
  end
end