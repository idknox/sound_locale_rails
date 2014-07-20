require "sinatra"
require "sinatra/content_for"
require "active_record"
require "rack-flash"
require "date"
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
    if session[:id] == 1
      erb :admin, :locals => {:users => @db.get_users(session[:id])}
    else
      erb :home, :locals => {
        :cur_user => @db.get_name(session[:id]),
        :venues => @db.get_venues
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

  delete "/admin/:id" do
    flash[:notice] = "#{@db.get_name(params[:id])} deleted"
    @db.delete_user(params[:id])
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
    if !@db.user_exists(email)
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

end
