class TicketflyController < ApplicationController

  def create
    Event.get_ticketfly_events.each { |event| Event.create(event) }
    flash[:notice] = "Ticketfly events successfully pulled"
    redirect_to root_path
  end
end
