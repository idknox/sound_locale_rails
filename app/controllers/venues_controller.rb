class VenuesController < ApplicationController
  def map
    @venues = Venue.all
    puts "*" * 80
    puts @venues
    puts "*" * 80
  end
end
