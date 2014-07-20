require "date"
require "sinatra"
require "sinatra/content_for"
require "rack-flash"
require_relative "lib/model/table_connection"

class App < Sinatra::Application
  helpers Sinatra::ContentFor
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @db = Table_connection.new
  end

  get "/" do
    venues = sort_list(@db.get_venue, params[:sort_venues])
    users = sort_list(@db.get_users(session[:id]), params[:sort_users])

    if session[:id] == 1
      erb :admin, :locals => {
        :users => users,
        :venues => venues
      }
    else
      erb :home, :locals => {
        :cur_user => @db.get_name(session[:id]),
        :venues => venues
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

  get "ven_:marker" do
    erb :venue, :locals => {:venues => @db.get_venue(params[:marker])}
  end
  post "/" do
    check_login(params[:email], params[:password])
  end

  post "/register" do
    check_reg(params)
  end

  post "/pw" do
    if !@db.get_pw(session[:id], params[:old_pw])
      flash[:notice] = "Incorrect Password"
      redirect back
    elsif check_pw(params[:new_pw], params[:new_conf])
      flash[:notice] = "Passwords don't match"
      redirect back
    else
      @db.change_pw(session[:id], params[:new_pw])
      flash[:notice] = "Password changed"
      redirect "/"
    end
  end

  get "/add_venue" do
    erb :add_venue
  end

  post "/add_venue" do
    @db.add_venue(params)
    flash[:notice] = "#{params["name"]} added"
    redirect "/"
  end

  delete "/admin/del_user:id" do
    flash[:notice] = "#{@db.get_name(params[:id])} deleted"
    @db.delete_user(params[:id])
    redirect "/"
  end

  delete "/admin/del_venue:marker" do
    flash[:notice] = "#{@db.get_venue(params[:marker])["title"]} deleted"
    @db.delete_venue(params[:marker])
    redirect "/"
  end

  private

  def check_reg(params)
    if !check_pw(params[:password], params[:pass_conf])
      flash[:notice] = "Passwords must match"
      redirect back
    elsif @db.user_exists(params[:email])
      flash[:notice] = "User already exists"
      redirect back
    else
      @db.add_user(params)
      flash[:notice] = "Thank you for registering"
      redirect "/"
    end
  end

  def check_login(email, password)
    if email == "" || password == ""
      flash[:notice] = "email and password are required"
      redirect back
    elsif !@db.user_exists(email)
      flash[:notice] = "No account exists"
      redirect back
    elsif @db.user_exists(email)["password"] != password
      flash[:notice] = "Incorrect password"
      redirect back
    else
      session[:id] = @db.user_exists(email)["id"].to_i
      redirect "/"
    end
  end

  def check_pw(pw1, pw2)
    pw1 == pw2
  end

  def sort_list(array, param)
    if param == "user_name"
      array.sort_by! { |user| user["last_name"] }.sort_by! { |user| user["first_name"] }
    elsif param
      array.sort_by! { |item| item[param] }
    else
      array
    end
  end
end
