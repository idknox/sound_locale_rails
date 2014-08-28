class TicketflyeventsController < ApplicationController

  def create
    TicketflyEvents.all.each { |event| Event.create(event) }
    flash[:notice] = "Ticketfly events successfully pulled"
    redirect_to root_path
  end
end
