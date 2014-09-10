namespace :venues do
  desc "destroys and reseeds venues"
  task reseed: :environment do
    Venue.destroy_all
    Rake::Task["db:seed"].invoke
  end
end
