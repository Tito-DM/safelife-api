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

ActiveRecord::Schema.define(version: 2021_09_30_094344) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "answers_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "request_id", null: false
    t.uuid "donor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["donor_id"], name: "index_answers_requests_on_donor_id"
    t.index ["request_id"], name: "index_answers_requests_on_request_id"
  end

  create_table "api_v1_answers_requests", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "donors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.date "birthdate"
    t.float "weight"
    t.string "blood"
    t.integer "status"
    t.string "province"
    t.string "gender"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_donors_on_user_id"
  end

  create_table "motifications", force: :cascade do |t|
    t.uuid "request_id", null: false
    t.uuid "user_id", null: false
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_id"], name: "index_motifications_on_request_id"
    t.index ["user_id"], name: "index_motifications_on_user_id"
  end

  create_table "notification_donor_to_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "request_id", null: false
    t.uuid "donor_id", null: false
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["donor_id"], name: "index_notification_donor_to_requests_on_donor_id"
    t.index ["request_id"], name: "index_notification_donor_to_requests_on_request_id"
  end

  create_table "notification_resquest_to_donors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "request_id", null: false
    t.uuid "donor_id", null: false
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["donor_id"], name: "index_notification_resquest_to_donors_on_donor_id"
    t.index ["request_id"], name: "index_notification_resquest_to_donors_on_request_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.uuid "request_id", null: false
    t.uuid "user_id", null: false
    t.string "type"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_id"], name: "index_notifications_on_request_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.integer "type_request"
    t.string "description"
    t.string "province"
    t.date "date_limit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "session_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
  add_foreign_key "motifications", "requests"
  add_foreign_key "motifications", "users"
  add_foreign_key "notification_donor_to_requests", "donors"
  add_foreign_key "notification_donor_to_requests", "requests"
  add_foreign_key "notification_resquest_to_donors", "donors"
  add_foreign_key "notification_resquest_to_donors", "requests"
  add_foreign_key "notifications", "requests"
  add_foreign_key "notifications", "users"
  add_foreign_key "requests", "users"
end
