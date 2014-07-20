require "sinatra"
require "sinatra/content_for"
require "active_record"
require "gschool_database_connection"
require "rack-flash"
require "date"

class App < Sinatra::Application
  helpers Sinatra::ContentFor
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])

  end

  get "/" do
    if session[:id] == 1
      erb :admin, :locals => {:users => get_users(session[:id])}
    else
      erb :home, :locals => {
        :cur_user => get_name(session[:id]),
        :venues => get_venues
      }
    end
  end

  get "/register" do
    erb :register
  end

  get "/pw" do
    erb :pw
  end

  get "/about" do
    erb :about
  end

  get "/logout" do
    session.delete(:id)
    redirect "/"
  end

  post "/" do
    check_login(params[:email], params[:password])
  end

  post "/register" do
    check_reg
  end

  post "/pw" do
    if !get_pw(session[:id], params[:old_pw])
      flash[:notice] = "Incorrect Password"
      redirect back
    elsif !check_pw(params[:new_pw], params[:new_conf])
      flash[:notice] = "Passwords don't match"
      redirect back
    else
      change_pw(session[:id], params[:new_pw])
      flash[:notice] = "Password changed"
      redirect "/"
    end
  end

  delete "/admin/:id" do
    flash[:notice] = "#{get_name(params[:id])} deleted"
    delete_user(params[:id])
    redirect "/"
  end

  private

  def check_reg
    if !check_pw(params[:password], params[:pass_conf])
      flash[:notice] = "Passwords must match"
      redirect back
    elsif user_exists(params[:email])
      flash[:notice] = "User already exists"
      redirect back
    else
      add_user
      flash[:notice] = "Thank you for registering"
      redirect "/"
    end
  end

  def check_login(email, password)
    if !user_exists(email)
      flash[:notice] = "No account exists"
      redirect back
    elsif user_exists(email)["password"] != password
      flash[:notice] = "Incorrect password"
      redirect back
    else
      session[:id] = user_exists(email)["id"].to_i
      redirect "/"
    end
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

  def check_pw(pw1, pw2)
    pw1 == pw2
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
