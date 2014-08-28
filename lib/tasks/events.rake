namespace :events do

  desc "Import events from Ticketfly"
  task :import_ticketfly_events => :environment do
    TicketflyEvents.all.each { |event| Event.create(event) }
  end

end
