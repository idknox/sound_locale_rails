class StubhubController < ApplicationController

  def create
    StubhubEvents.all.each { |event| Event.create(event) }
    flash[:notice] = "Stubhub events successfully pulled"
    redirect_to root_path
  end
end