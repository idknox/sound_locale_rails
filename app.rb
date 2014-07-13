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
    erb :home
  end

  get "/about" do
    erb :about
  end

end
