require "date"

class UserTable

  def initialize(db)
    @db = db
  end

  def user_exists(email)
    @db.sql(
      "SELECT * from users where email='#{email}'"
    ) != []
  end

  def find_by_email(email)
    @db.sql(
      "SELECT * from users WHERE email='#{email}'"
    )[0]
  end

  def add_user(user)
    @db.sql(
      "INSERT INTO users (first_name, last_name, email" +
        ", password, birthday, join_date) VALUES ('#{user[:first_name]}'" +
        ", '#{user[:last_name]}', '#{user[:email]}', '#{user[:password]}'," +
        " '#{Date.parse(user[:birthday]).strftime("%m-%d-%Y")}', '#{Date.today.strftime("%m-%d-%Y")}')"
    )
  end

  def get_user(id)
    if id
      @db.sql(
        "SELECT * FROM users WHERE id=#{id}"
      )[0]
    end
  end

  def get_id(email)
    @db.sql(
      "SELECT id FROM users WHERE email='#{email}'"
    )[0]["id"]
  end

  def get_users(id)
    if id
      @db.sql(
        "SELECT * FROM users WHERE id <> #{id}"
      )
    end
  end

  def delete_user(id)
    @db.sql(
      "DELETE from users WHERE id=#{id}"
    )
  end

  def get_email(id)
    if id
      @db.sql(
        "SELECT email from users WHERE id=#{id}"
      )
    end
  end

  def get_pw(id, pw)
    output = @db.sql(
      "SELECT password FROM users WHERE id=#{id} and password='#{pw}'"
    )
    if output != []
      output[0]["password"]
    end
  end

  def change_pw(id, pw)
    @db.sql(
      "UPDATE users SET password ='#{pw}' WHERE id=#{id}"
    )
  end

  def update_user(user)
    @db.sql(
      "UPDATE users SET first_name='#{user[:first_name]}', " +
        "last_name='#{user[:last_name]}', " +
        "email='#{user[:email]}', " +
        "birthday='#{Date.parse(user[:birthday]).strftime("%m-%d-%Y")}', " +
        "join_date='#{Date.today.strftime("%m-%d-%Y")}'"
    )
  end

end