# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160121065906) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.string  "name"
    t.string  "tickets"
    t.string  "url"
    t.string  "twitter"
    t.integer "vendor_id"
    t.string  "image"
    t.string  "headliner"
    t.integer "venue_id"
    t.string  "venue_name"
    t.string  "description"
    t.time    "doors"
    t.string  "opener"
    t.string  "soundcloud_url"
    t.string  "advance_price"
    t.string  "door_price"
    t.time    "show_start"
  end

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
