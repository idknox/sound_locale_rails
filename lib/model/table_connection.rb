require "gschool_database_connection"

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

  def add_user
    @database_connection.sql(
      "INSERT INTO users (first_name, last_name, email" +
        ", password, birthday, join_date) VALUES ('#{params[:first_name]}'" +
        ", '#{params[:last_name]}', '#{params[:email]}', '#{params[:password]}'," +
        " '#{params[:birthdate]}', '#{Date.today.strftime("%m-%e-%Y")}')"
    )
  end

  def get_name(id)
    if id
      @database_connection.sql(
        "SELECT first_name FROM users WHERE id=#{id}"
      )[0]["first_name"]
    end
  end

  def get_id(email)
    @database_connection.sql(
      "SELECT id FROM users WHERE email='#{email}'"
    )[0]["id"]
  end

  def get_users(id)
    @database_connection.sql(
      "SELECT * FROM users WHERE id <> #{id}"
    )
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

  def get_venues
    @database_connection.sql(
      "SELECT * FROM venues"
    )
  end

end

