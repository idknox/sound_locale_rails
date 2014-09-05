class VenuesController < ApplicationController
  def map
    @venues = Venue.all
    respond_to do |format|
      format.html
      format.json { render :json => @venues }
    end
  end

  def list
    @venues = Venue.all
  end

  def show
    @venue = Venue.find(params[:id])
  end
end
