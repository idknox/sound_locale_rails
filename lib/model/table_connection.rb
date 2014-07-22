require "gschool_database_connection"
require "date"

class Table_connection

  def initialize
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

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

  def add_venue(venue)
    @database_connection.sql(
      "INSERT INTO venues (title, position, background, " +
        "marker_name, address, size, description, price, map) " +
        "VALUES ('#{venue[:name]}', '#{venue[:position]}', " +
        "'#{venue[:background]}', '#{venue[:marker_name]}', " +
        "'#{venue[:address]}', '#{venue[:size]}', " +
        "'#{venue[:description]}', '#{venue[:price]}', '#{venue[:map]}')"
    )
  end

  def get_venue(marker=nil)
    if marker
      @database_connection.sql(
        "SELECT * FROM venues WHERE marker_name='#{marker}'"
      )
    else
      @database_connection.sql(
        "SELECT * FROM venues"
      )
    end
  end

  def delete_venue(marker)
    @database_connection.sql(
      "DELETE FROM venues WHERE marker_name='#{marker}'"
    )
  end
end

