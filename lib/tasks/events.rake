namespace :events do

  desc "Import events from Ticketfly"
  task tf: :environment do
    count = 0
    Ticketfly.events.each do |event|
      event = event.select { |_, v| v.is_a?(String) ? v.length < 230 : true }
      event = Event.new(event)
      count += 1 if event.save
    end
    print_count(count, "PULLED")
    EventsMailer.ticketfly_pull(count).deliver if Rails.env.production?
  end

  desc "Import events from Stubhub"
  task sh: :environment do
    count = 0
    Stubhub.events.each { |event| count += 1 if Event.new(event).save }
    print_count(count, "PULLED")
    EventsMailer.stubhub_pull(count).deliver if Rails.env.production?
  end

  desc "Import events from Songkick"
  task sk: :environment do
    count = 0
    Songkick.events.each { |event| count += 1 if Event.new(event).save }
    print_count(count, "PULLED")
    EventsMailer.songkick_pull(count).deliver if Rails.env.production?
  end

  desc "Import custom events"
  task kimono: :environment do
    count = 0
    Kimono.events.each { |event| count += 1 if Event.new(event).save }
    print_count(count, "PULLED")
  end

  desc "Import Westword events"
  task westword: :environment do
    count = 0
    Westword.events.each { |event| count += 1 if Event.new(event).save }
    print_count(count, "PULLED")
  end

  desc "Import AXS events"
  task axs: :environment do
    count = 0
    Axs.events.each { |event| count += 1 if Event.new(event).save }
    print_count(count, "PULLED")
  end

  desc "Import events events"
  task all: :environment do
    Rake::Task["events:axs"].invoke
    Rake::Task["events:tf"].invoke
    Rake::Task["events:kimono"].invoke
    Rake::Task["events:sh"].invoke
    Rake::Task["events:sk"].invoke
  end

  desc "Destroy events events"
  task destroy: :environment do
    count = Event.all.length
    Event.destroy_all
    print_count(count, "DESTROYED")
  end


  private

  def print_count(count, action)
    puts "*" * 80
    puts "#{count} EVENTS #{action}"
    puts "*" * 80
  end
end
