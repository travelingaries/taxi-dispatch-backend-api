# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_19_071817) do
  create_table "taxi_requests", force: :cascade do |t|
    t.integer "passenger_id", limit: 11, null: false
    t.integer "driver_id", limit: 11
    t.string "address", limit: 255, null: false
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "accepted_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "type", limit: 255
    t.string "email", limit: 255, null: false
    t.string "password", limit: 255, null: false
    t.string "token", limit: 255
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "data"
  end

end
