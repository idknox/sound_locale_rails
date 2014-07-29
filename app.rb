require "date"
require "sinatra"
require "sinatra/content_for"
require "rack-flash"
require "gschool_database_connection"
require_relative "lib/model/JsonEvents"
require_relative "lib/model/TflyTable"
require_relative "lib/model/User"
require_relative "lib/model/Venue"

class App < Sinatra::Application
  helpers Sinatra::ContentFor
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @db = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    @users = User.new(@db)
    @tf = TflyTable.new(@db)
    @jsonevents = JsonEvents.new
  end

  get "/" do
    events = @tf.find_by_date(params[:date])
    erb :home, :locals => {:events => events}
  end

  before "/admin/*" do
    unless is_admin
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
    erb :pw, :locals => {:cur_user => @users.find(params[:id])}
  end

  post "/users/:id/pw" do
    if !@users.get_pw(session[:id], params[:old_pw])
      flash[:notice] = "Incorrect Password"
      redirect back
    elsif !check_pw(params[:new_pw], params[:new_conf])
      flash[:notice] = "Passwords don't match"
      redirect back
    else
      @users.change_pw(session[:id], params[:new_pw])
      flash[:notice] = "Password changed"
      redirect "/"
    end
  end

  get "/admin/venues/new" do
    erb :add_venue
  end

  get "/admin/venues" do
    venues = filter_list(sort_list(Venue.all, params[:sort]), params[:filter])
    erb :ad_venues, :locals => {:venues => venues}
  end

  get "/admin/users" do
    users = sort_list(@users.all(session[:id]), params[:sort])
    erb :ad_users, :locals => {:users => users}
  end

  get "/venues" do
    venues = sort_list(Venue.all, params[:sort_venues])
    erb :venues, :locals => {:venues => venues}
  end

  get "/venues/map" do
    venues = filter_list(sort_list(Venue.all, params[:sort_venues]), params[:filter])
    erb :venues_map, :locals => {:venues => venues}
  end

  get "/venues/:id" do
    venue = Venue.find(params[:id])
    erb :venue, :locals => {
      :venue => venue,
      :cur_user => @users.find(session[:id]),
      :events => @tf.find_by_venue(venue.title)
    }
  end

  get "/admin/users/:id/edit" do
    erb :user_edit, :locals => {:user => @users.find(params[:id])}
  end

  get "/admin/venues/:id/edit" do
    erb :venue_edit, :locals => {:venue => Venue.find(params[:id])}
  end

  get "/admin/ticketfly" do
    erb :ad_events, :locals => {:events => sort_list(@tf.all, params[:sort])}
  end

  get "/admin/ticketfly/:id/edit" do
    erb :tf_edit, :locals => {:event => @tf.find(params[:id])}
  end

  post "/admin/ticketfly" do
    @tf.create(@jsonevents.get_tf)
    redirect "/admin/ticketfly"
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
      Venue.create(params)
      flash[:notice] = "#{params[:name]} added"
      redirect "/"
    end
  end

  patch "/venues/:id" do
    puts "*" * 80
    p params
    puts "*" * 80
    params.delete("_method")
    params.delete("splat")
    params.delete("captures")
    Venue.find(params[:id]).update(params)
    flash[:notice] = "Venue Updated"
    redirect back
  end

  patch "/users/:id" do
    @users.update(params)
    flash[:notice] = "User updated"
    redirect back
  end

  patch "/ticketfly/:id" do
    @tf.update(params)
    flash[:notice] = "Event updated"
    redirect back
  end

  delete "/users/:id" do
    flash[:notice] = "#{@users.find(params[:id])["first_name"]} deleted"
    @users.delete(params[:id])
    redirect back
  end

  delete "/venues/:id" do
    flash[:notice] = "#{Venue.find(params[:id]).title} deleted"
    Venue.destroy(params[:id])
    redirect back
  end

  delete "/ticketfly/:id" do
    flash[:notice] = "Event deleted"
    @tf.delete(params[:id])
    redirect back
  end

  delete "/admin/ticketfly" do
    @tf.del_all
    flash[:notice] = "All events deleted"
    redirect back
  end

  private

  def is_admin
    session[:id] == 1
  end

  def check_reg(params)
    if !check_pw(params[:password], params[:pass_conf])
      flash[:notice] = "Passwords must match"
      redirect back
    elsif @users.user_exists(params[:email])
      flash[:notice] = "User already exists"
      redirect back
    elsif get_age(params[:birthday]) < 13
      flash[:notice] = "You must be at least 13 years old"
      redirect back
    else
      @users.create(params)
      flash[:notice] = "Thank you for registering"
      redirect "/"
    end
  end

  def check_login(email, password)
    if email == "" || password == ""
      flash[:notice] = "email and password are required"
      redirect back
    elsif !@users.user_exists(email)
      flash[:notice] = "No account exists"
      redirect back
    elsif @users.find_by_email(email)["password"] != password
      flash[:notice] = "Incorrect password"
      redirect back
    else
      session[:id] = @users.find_by_email(email)["id"].to_i
      flash[:notice] = nil
      redirect "/"
    end
  end

  def check_pw(pw1, pw2)
    pw1 == pw2
  end

  def sort_list(array, param)
    if param == "user_name"
      array.order(:last_name).order(:first_name)
    elsif param
      array.order(param)
    else
      array
    end
  end

  def filter_list(relation, param)
    if param
      relation.where("#{param.split(': ')[0]}" => "#{param.split(': ')[1]}")
    else
      relation
    end
  end

  def get_age(bday)
    bday = Date.parse(bday)
    now = Time.now.utc.to_date
    now.year - bday.year - ((now.month > bday.month || (now.month == bday.month && now.day >= bday.day)) ? 0 : 1)
  end

end
