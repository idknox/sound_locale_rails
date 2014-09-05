class HerokuSchema < ActiveRecord::Migration
  def change
    create_table "users", force: true do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "email"
      t.date   "join_date"
      t.string "password_digest"
    end

    create_table "venues", force: true do |t|
      t.string "title"
      t.string "icon"
      t.string "marker_name"
      t.string "address"
      t.string "size"
      t.string "price"
      t.string "map"
      t.string "logo"
      t.string "background"
      t.string "site"
      t.string "name"
      t.text   "description"
      t.string "second_name"
      t.string "location"
    end
  end
end
