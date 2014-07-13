require "sinatra"
require "active_record"
# require "./lib/database_connection"
require "rack-flash"


class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    # @database_connection = DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    login_check
  end

  get "/about" do
    erb :about
  end

  post "/" do
    erb :loggedin
  end

  private

  def login_check(id)
    if params[:register]
      erb :register
    elsif session[:id]
      erb :loggedin {:cur_user => cur}
    else
      erb :home
    end
  end
end
