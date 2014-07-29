require "date"
require "active_record"

class User
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

  def create(user)
    @db.sql(
      "INSERT INTO users (first_name, last_name, email" +
        ", password, birthday, join_date) VALUES ('#{user[:first_name]}'" +
        ", '#{user[:last_name]}', '#{user[:email]}', '#{user[:password]}'," +
        " '#{Date.parse(user[:birthday]).strftime("%m-%d-%Y")}', '#{Date.today.strftime("%m-%d-%Y")}')"
    )
  end

  def find(id)
    if id
      @db.sql(
        "SELECT * FROM users WHERE id=#{id}"
      )[0]
    end
  end

  def all(id)
    if id
      @db.sql(
        "SELECT * FROM users WHERE id <> #{id}"
      )
    end
  end

  def delete(id)
    @db.sql(
      "DELETE from users WHERE id=#{id}"
    )
  end

  def change_pw(id, pw)
    @db.sql(
      "UPDATE users SET password ='#{pw}' WHERE id=#{id}"
    )
  end

  def update(user)
    @db.sql(
      "UPDATE users SET first_name='#{user[:first_name]}', " +
        "last_name='#{user[:last_name]}', " +
        "email='#{user[:email]}', " +
        "birthday='#{Date.parse(user[:birthday]).strftime("%m-%d-%Y")}', " +
        "join_date='#{Date.today.strftime("%m-%d-%Y")}'"
    )
  end

end