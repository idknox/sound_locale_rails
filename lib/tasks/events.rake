namespace :events do

  desc "Import events from Ticketfly"
  task :import_ticketfly_events => :environment do
    count = 0
    TicketflyEvents.all.each { |event| count += 1 if Event.new(event).save }

    puts "*" * 80
    puts "#{count} EVENTS PULLED"
    puts "*" * 80
  end

  desc "Destroy all events"
  task :destroy_all_events => :environment do
    count = Event.all.length
    Event.destroy_all

    puts "*" * 80
    puts "#{count} EVENTS DESTROYED"
    puts "*" * 80
  end
end
