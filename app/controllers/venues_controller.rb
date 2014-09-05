class VenuesController < ApplicationController
  def map
    @venues = Venue.all
    respond_to do |format|
      format.html
      format.json { render :json => @venues }
  end

  def list
    @venues = Venue.all
    end
  end

  def show
  end
end
