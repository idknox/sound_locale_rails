require "gschool_database_connection"
require "date"

class TableConnection

  def initialize
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  # USERS

  def user_exists(email)
    user = @database_connection.sql(
      "SELECT * from users where email ='#{email}'"
    )
    if user != []
      user[0]
    end
  end

  def add_user(user)
    @database_connection.sql(
      "INSERT INTO users (first_name, last_name, email" +
        ", password, birthday, join_date) VALUES ('#{user[:first_name]}'" +
        ", '#{user[:last_name]}', '#{user[:email]}', '#{user[:password]}'," +
        " '#{Date.parse(user[:birthday]).strftime("%m-%d-%Y")}', '#{Date.today.strftime("%m-%d-%Y")}')"
    )
  end

  def get_user(id)
    if id
      @database_connection.sql(
        "SELECT * FROM users WHERE id=#{id}"
      )[0]
    end
  end

  def get_id(email)
    @database_connection.sql(
      "SELECT id FROM users WHERE email='#{email}'"
    )[0]["id"]
  end

  def get_users(id)
    if id
      @database_connection.sql(
        "SELECT * FROM users WHERE id <> #{id}"
      )
    end
  end

  def delete_user(id)
    @database_connection.sql(
      "DELETE from users WHERE id=#{id}"
    )
  end

  def get_email(id)
    if id
      @database_connection.sql(
        "SELECT email from users WHERE id=#{id}"
      )
    end
  end

  def get_pw(id, pw)
    output = @database_connection.sql(
      "SELECT password FROM users WHERE id=#{id} and password='#{pw}'"
    )
    if output != []
      output[0]["password"]
    end
  end

  def change_pw(id, pw)
    @database_connection.sql(
      "UPDATE users SET password ='#{pw}' WHERE id=#{id}"
    )
  end

  def update_user(user)
    @database_connection.sql(
      "UPDATE users SET first_name='#{user[:first_name]}', " +
        "last_name='#{user[:last_name]}', " +
        "email='#{user[:email]}', " +
        "birthday='#{Date.parse(user[:birthday]).strftime("%m-%d-%Y")}', " +
        "join_date='#{Date.today.strftime("%m-%d-%Y")}'"
    )
  end

  # VENUES

  def add_venue(venue)
    @database_connection.sql(
      "INSERT INTO venues (name, title, site, position, background, " +
        "marker_name, address, size, description, price, map) " +
        "VALUES ('#{venue[:name]}', '#{venue[:title]}', '#{venue[:site]}', '#{venue[:position]}', " +
        "'#{venue[:background]}', '#{venue[:marker_name]}', " +
        "'#{venue[:address]}', '#{venue[:size]}', " +
        "'#{venue[:description]}', '#{venue[:price]}', '#{venue[:map]}')"
    )
  end

  def get_venue(id)
    @database_connection.sql(
      "SELECT * FROM venues WHERE id =#{id}"
    )[0]
  end

  def get_venues
    @database_connection.sql(
      "SELECT * FROM venues"
    )
  end

  def update_venue(venue)
    @database_connection.sql(
      "UPDATE venues set title='#{venue[:title]}', " +
        "position='#{venue[:position]}', background='#{venue[:background]}', " +
        "marker_name='#{venue[:marker_name]}', " +
        "address='#{venue[:address]}', size='#{venue[:size]}', " +
        "description='#{venue[:description]}', price='#{venue[:price]}', " +
        "map='#{venue[:map]}', logo='#{venue[:logo]}', site='#{venue[:site]}', " +
        "name='#{venue[:name]}' WHERE id=#{venue[:id]}"
    )
  end

  def delete_venue(id)
    @database_connection.sql(
      "DELETE FROM venues WHERE id=#{id}"
    )
  end

  # EVENTS - TICKETFLY

  def insert_tf(events)
    events.each do |event|
      event["name"].gsub!("'", "''")
      event["venue"]["name"].gsub!("'", "''")
      event["headlinersName"].gsub!("'", "''")
      @database_connection.sql(
        "INSERT INTO events (name, venue, headliner, date, tickets, price, url, twitter) VALUES " +
          "('#{event["name"]}', '#{event["venue"]["name"]}', '#{event["headlinersName"]}', " +
          "'#{Date.parse(event["startDate"]).strftime("%m-%d-%Y")}', " +
          "'#{event["ticketPurchaseUrl"]}', '#{event["ticketPrice"]}', " +
          "'#{event["urlOfficialWebsite"]}', '#{event["urlTwitter"]}')"
      )
    end
  end

  def get_tf(venue=nil)
    if venue
      @database_connection.sql(
        "SELECT * FROM events" +
          "INNER JOIN venues ON venues.title=events.venue" +
          "WHERE events.venue = '#{venue}'"
      )
    else
      @database_connection.sql(
        "SELECT * FROM events"
      )
    end
  end

  def
  end

