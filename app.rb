require "date"
require "sinatra"
require "sinatra/content_for"
require "rack-flash"
require "gschool_database_connection"
require_relative "lib/model/jsonevents"
require_relative "lib/model/events"
require_relative "lib/model/users"
require_relative "lib/model/venues"

class App < Sinatra::Application
  helpers Sinatra::ContentFor
  enable :sessions
  use Rack::Flash

  def initialize
    super
    GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    @jsonevents = JsonEvents.new
  end

  before "/admin/*" do
    unless User.is_admin?(session[:id])
      redirect "/"
    end
  end

  after do
    ActiveRecord::Base.clear_active_connections!
  end

  get "/" do
    user = User.find(session[:id]) if session[:id]
    events = Event.find_by(:date => params[:date]) || []

    erb :home, :locals => {
      :events => events,
      :cur_user => user
    }
  end

  get "/logout" do
    session.delete(:id)
    redirect "/"
  end

  get "/users/new" do
    erb :register
  end

  get "/users/:id/pw/edit" do
    erb :pw, :locals => {:cur_user => User.find(params[:id])}
  end

  get "/admin/venues/new" do
    erb :add_venue
  end

  get "/admin/venues" do
    venues = filter_list(sort_list(Venue.all, params[:sort]), params[:filter])
    erb :ad_venues, :locals => {:venues => venues}
  end

  get "/admin/users" do
    users = sort_list(User.all, params[:sort])
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
      :events => Event.where(:venue => venue.title)
    }
  end

  get "/admin/users/:id/edit" do
    erb :user_edit, :locals => {:user => User.find(params[:id])}
  end

  get "/admin/venues/:id/edit" do
    erb :venue_edit, :locals => {:venue => Venue.find(params[:id])}
  end

  get "/admin/events" do
    erb :ad_events, :locals => {:events => sort_list(Event.all, params[:sort])}
  end

  get "/admin/events/:id/edit" do
    erb :event_edit, :locals => {:event => Event.find(params[:id])}
  end

  post "/admin/events" do
    if params[:tf]
    @jsonevents.get_tf.each { |event| Event.create(event) }
    elsif params[:sh]
      @jsonevents.get_sh.each { |event| Event.create(event) }    end
    redirect "/admin/events"
  end

  post "/" do
    user = User.find_by(
      :email => params[:email],
      :password => params[:password]
    )
    if user
      session[:id] = User.find_by(:email => params[:email]).id
      flash[:notice] = nil
    else
      flash[:notice] = "Invalid credentials"
    end
    redirect "/"
  end

  post "/users" do
    user = User.new(params)
    user.join_date = Date.today.strftime("%Y-%m-%d")

    if user.save
      flash[:notice] = "Thanks for registering"
      redirect "/"
    else
      flash[:notice] = user.errors.full_messages.first
      redirect back
    end
  end

  post "/users/:id/pw" do
    if User.find(session[:id]).password != params[:old_pw]
      flash[:notice] = "Incorrect Password"
      redirect back
    elsif !check_pw(params[:new_pw], params[:new_conf])
      flash[:notice] = "Passwords don't match"
      redirect back
    else
      User.find(session[:id]).update(password: params[:new_pw])
      flash[:notice] = "Password changed"
      redirect "/"
    end
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
    params.delete("_method")
    params.delete("splat")
    params.delete("captures")
    Venue.find(params[:id]).update(params)
    flash[:notice] = "Venue Updated"
    redirect back
  end

  patch "/users/:id" do
    params.delete("_method")
    params.delete("splat")
    params.delete("captures")
    User.find(params[:id]).update(params)
    flash[:notice] = "User updated"
    redirect back
  end

  patch "/ticketfly/:id" do
    Event.update(params)
    flash[:notice] = "Event updated"
    redirect back
  end

  delete "/users/:id" do
    flash[:notice] = "#{User.find(params[:id]).first_name} deleted"
    User.destroy(params[:id])
    redirect back
  end

  delete "/venues/:id" do
    flash[:notice] = "#{Venue.find(params[:id]).title} deleted"
    Venue.destroy(params[:id])
    redirect back
  end

  delete "/ticketfly/:id" do
    flash[:notice] = "Event deleted"
    Event.destroy(params[:id])
    redirect back
  end

  delete "/admin/ticketfly" do
    Event.destroy_all
    flash[:notice] = "All events deleted"
    redirect back
  end

  private


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


end
