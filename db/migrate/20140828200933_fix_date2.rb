class FixDate2 < ActiveRecord::Migration
  def change
    create_table "events", force: true do |t|
      t.string "name"
      t.string "tickets"
      t.string "url"
      t.string "twitter"
      t.string "price"
      t.integer "vendor_id"
      t.string "image"
      t.string "headliner"
      t.integer "venue_id"
      t.string "venue_name"
      t.string "description"
      t.time "time"
      t.datetime "date"
    end
  end
end
