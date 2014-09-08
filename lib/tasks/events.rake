namespace :events do

  desc "Import events from Ticketfly"
  task :tf => :environment do
    count = 0
    TicketflyEvents.all.each { |event| count += 1 if Event.new(event).save }
    print_count(count, "PULLED")
    EventsMailer.ticketfly_pull(count).deliver
  end

  desc "Import events from Stubhub"
  task :sh => :environment do
    count = 0
    StubhubEvents.all.each { |event| count += 1 if Event.new(event).save }
    print_count(count, "PULLED")
    EventsMailer.stubhub_pull(count).deliver
  end

  desc "Import events from Songkick"
  task :sk => :environment do
    count = 0
    SongkickEvents.all.each { |event| count += 1 if Event.new(event).save }
    print_count(count, "PULLED")
    EventsMailer.songkick_pull(count).deliver
  end

  desc "Destroy all events"
  task :destroy => :environment do
    count = Event.all.length
    Event.destroy_all
    print_count(count, "DESTROYED")
  end

  desc "Import all events"
  task :all => :environment do
    Rake::Task["events:tf"].invoke
    Rake::Task["events:sh"].invoke
    Rake::Task["events:sk"].invoke
  end

  private

  def print_count(count, action)
    puts "*" * 80
    puts "#{count} EVENTS #{action}"
    puts "*" * 80
  end
end
