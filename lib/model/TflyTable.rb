require "date"

class TflyTable

  def initialize(db)
    @db = db
  end

  def all
    @db.sql(
      "SELECT * FROM events"
    )
  end

  def create(events)
    events.each do |event|
      event["name"].gsub!("'", "''")
      event["venue"]["name"].gsub!("'", "''")
      event["headlinersName"].gsub!("'", "''")
      @db.sql(
        "INSERT INTO events (name, venue, headliner, date, tickets, price, url, twitter) VALUES " +
          "('#{event["name"]}', '#{event["venue"]["name"]}', '#{event["headlinersName"]}', " +
          "'#{Date.parse(event["startDate"]).strftime("%m-%d-%Y")}', " +
          "'#{event["ticketPurchaseUrl"]}', '#{event["ticketPrice"]}', " +
          "'#{event["urlOfficialWebsite"]}', '#{event["urlTwitter"]}')"
      )
    end
  end

  def get_tf(venue)
      @db.sql(
        "SELECT * FROM events" +
          "INNER JOIN venues ON venues.title=events.venue" +
          "WHERE events.venue = '#{venue}'"
      )
  end
end