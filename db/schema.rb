# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_15_191309) do

  create_table "answers_requests", force: :cascade do |t|
    t.integer "request_id", null: false
    t.integer "donor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["donor_id"], name: "index_answers_requests_on_donor_id"
    t.index ["request_id"], name: "index_answers_requests_on_request_id"
  end

  create_table "api_v1_answers_requests", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "donors", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "birthdate"
    t.float "weight"
    t.string "blood"
    t.integer "status"
    t.string "province"
    t.integer "gender"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_donors_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "type_request"
    t.string "description"
    t.string "province"
    t.date "date_limit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "authentication_token", limit: 30
    t.string "phone"
    t.integer "type_user"
    t.string "name"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "answers_requests", "donors"
  add_foreign_key "answers_requests", "requests"
  add_foreign_key "donors", "users"
  add_foreign_key "requests", "users"
end
