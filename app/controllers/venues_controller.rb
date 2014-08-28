class VenuesController < ApplicationController
  def map
    @venues = Venue.all
  end

  def list
    @venues = Venue.all
  end

  def show

  end
end
