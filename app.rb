require "date"
require "sinatra"
require "sinatra/content_for"
require "rack-flash"
require_relative './lib/model/table_connection'

class App < Sinatra::Application
  helpers Sinatra::ContentFor
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @db = Table_connection.new
  end

  get "/" do
    venues = filter_list(sort_list(@db.get_venues, params[:sort_venues]), params[:filter])
    user = @db.get_user(session[:id])

    erb :home, :locals => {
      :cur_user => user,
      :venues => venues
    }
  end

  before "/admin/*" do
    unless is_admin?
      redirect "/"
    end
  end

  get "/logout" do
    session.delete(:id)
    redirect "/"
  end

  get "/users/new" do
    erb :register
  end

  get "/users/:id/pw/edit" do
    erb :pw, :locals => {:cur_user => @db.get_user(params[:id])}
  end

  post "/users/:id/pw" do
    if !@db.get_pw(session[:id], params[:old_pw])
      flash[:notice] = "Incorrect Password"
      redirect back
    elsif !check_pw(params[:new_pw], params[:new_conf])
      flash[:notice] = "Passwords don't match"
      redirect back
    else
      @db.change_pw(session[:id], params[:new_pw])
      flash[:notice] = "Password changed"
      redirect "/"
    end
  end

  get "/admin/venues/new" do
    erb :add_venue
  end

  get "/admin/venues" do
    venues = filter_list(sort_list(@db.get_venues, params[:sort]), params[:filter])

    erb :ad_venues, :locals => {:venues => venues}
  end

  get "/admin/users" do
    users = sort_list(@db.get_users(session[:id]), params[:sort])
    erb :ad_users, :locals => {:users => users}
  end

  get "/venues" do
    erb :venues, :locals => {
      :venues => sort_list(@db.get_venues, "title"),
      :cur_user => @db.get_user(session[:id])
    }
  end

  get "/venues/:id" do
    erb :venue, :locals => {
      :venue => @db.get_venue(params[:id]),
      :cur_user => @db.get_user(session[:id])
    }
  end

  get "/admin/users/:id/edit" do
    erb :user_edit, :locals => {:user => @db.get_user(params[:id])}
  end

  get "/admin/venues/:id/edit" do
    erb :venue_edit, :locals => {:venue => @db.get_venue(params[:id])}
  end

  post "/" do
    check_login(params[:email], params[:password])
  end

  post "/users" do
    check_reg(params)
  end


  post "/venues" do
    desc = params[:description].length
    if desc > 255
      flash[:notice] = "Description is #{desc-255} chars too long"
      redirect back
    else
      @db.add_venue(params)
      flash[:notice] = "#{params["name"]} added"
      redirect "/"
    end
  end

  patch "/venues/:id" do
    @db.update_venue(params)
    flash[:notice] = "Venue Updated"
    redirect back
  end

  patch "/users/:id" do
    @db.update_user(params)
    flash[:notice] = "User updated"
    redirect back
  end

  delete "/users/:id" do
    flash[:notice] = "#{@db.get_user(params[:id])["first_name"]} deleted"
    @db.delete_user(params[:id])
    redirect back
  end

  delete "/venues/:id" do
    flash[:notice] = "#{@db.get_venue(params[:id])["title"]} deleted"
    @db.delete_venue(params[:id])
    redirect back
  end

  private

  def is_admin?
    session[:id] == 1
  end

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
      flash[:notice] = nil
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

  def filter_list(array, param)
    if param
      array.select { |item| item[param.split(": ")[0]] == param.split(": ")[1] }
    else
      array
    end
  end

end
