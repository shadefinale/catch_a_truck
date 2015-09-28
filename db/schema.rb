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

ActiveRecord::Schema.define(version: 20150928173630) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "food_trucks", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "address",    null: false
    t.string   "food_items", null: false
    t.float    "latitude",   null: false
    t.float    "longitude",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "food_trucks", ["food_items"], name: "index_food_trucks_on_food_items", using: :btree
  add_index "food_trucks", ["latitude", "longitude"], name: "index_food_trucks_on_latitude_and_longitude", using: :btree
  add_index "food_trucks", ["name"], name: "index_food_trucks_on_name", using: :btree

end
