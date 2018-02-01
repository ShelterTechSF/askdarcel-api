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

ActiveRecord::Schema.define(version: 20180201023804) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "attention"
    t.string   "address_1",      null: false
    t.string   "address_2"
    t.string   "address_3"
    t.string   "address_4"
    t.string   "city",           null: false
    t.string   "state_province", null: false
    t.string   "postal_code",    null: false
    t.string   "country",        null: false
    t.integer  "resource_id",    null: false
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.index ["resource_id"], name: "index_addresses_on_resource_id", using: :btree
  end

  create_table "admins", force: :cascade do |t|
    t.string   "provider",           default: "email", null: false
    t.string   "uid",                default: "",      null: false
    t.string   "encrypted_password", default: "",      null: false
    t.integer  "sign_in_count",      default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "email"
    t.json     "tokens"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["email"], name: "index_admins_on_email", using: :btree
    t.index ["uid", "provider"], name: "index_admins_on_uid_and_provider", unique: true, using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "name",                       null: false
    t.boolean  "top_level",  default: false, null: false
    t.index ["name"], name: "index_categories_on_name", unique: true, using: :btree
  end

  create_table "categories_keywords", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "keyword_id",  null: false
  end

  create_table "categories_resources", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "resource_id", null: false
    t.index ["category_id"], name: "index_categories_resources_on_category_id", using: :btree
    t.index ["resource_id"], name: "index_categories_resources_on_resource_id", using: :btree
  end

  create_table "categories_services", id: false, force: :cascade do |t|
    t.integer "service_id",  null: false
    t.integer "category_id", null: false
  end

  create_table "change_requests", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "type"
    t.integer  "object_id"
    t.integer  "status",      default: 0
    t.integer  "action",      default: 1
    t.integer  "resource_id"
    t.index ["resource_id"], name: "index_change_requests_on_resource_id", using: :btree
  end

  create_table "eligibilities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "eligibilities_services", id: false, force: :cascade do |t|
    t.integer "service_id",     null: false
    t.integer "eligibility_id", null: false
  end

  create_table "field_changes", force: :cascade do |t|
    t.string  "field_name"
    t.string  "field_value"
    t.integer "change_request_id", null: false
    t.index ["change_request_id"], name: "index_field_changes_on_change_request_id", using: :btree
  end

  create_table "keywords", force: :cascade do |t|
    t.string "name"
  end

  create_table "keywords_resources", id: false, force: :cascade do |t|
    t.integer "resource_id", null: false
    t.integer "keyword_id",  null: false
  end

  create_table "keywords_services", id: false, force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "keyword_id", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.text     "note"
    t.integer  "resource_id"
    t.integer  "service_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["resource_id"], name: "index_notes_on_resource_id", using: :btree
    t.index ["service_id"], name: "index_notes_on_service_id", using: :btree
  end

  create_table "phones", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "number",       null: false
    t.string   "service_type", null: false
    t.integer  "resource_id",  null: false
    t.index ["resource_id"], name: "index_phones_on_resource_id", using: :btree
  end

  create_table "programs", force: :cascade do |t|
    t.string   "name"
    t.string   "alternate_name"
    t.string   "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "resource_id"
    t.index ["resource_id"], name: "index_programs_on_resource_id", using: :btree
  end

  create_table "ratings", force: :cascade do |t|
    t.decimal "rating"
    t.integer "user_id",     null: false
    t.integer "resource_id"
    t.integer "service_id"
    t.index ["resource_id"], name: "index_ratings_on_resource_id", using: :btree
    t.index ["service_id"], name: "index_ratings_on_service_id", using: :btree
    t.index ["user_id", "resource_id", "service_id"], name: "index_ratings_on_user_id_and_resource_id_and_service_id", unique: true, using: :btree
    t.index ["user_id", "resource_id"], name: "index_ratings_on_user_id_and_resource_id", unique: true, using: :btree
    t.index ["user_id", "service_id"], name: "index_ratings_on_user_id_and_service_id", unique: true, using: :btree
  end

  create_table "resources", force: :cascade do |t|
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "name",                              null: false
    t.string   "short_description"
    t.text     "long_description"
    t.string   "website"
    t.datetime "verified_at"
    t.string   "email"
    t.integer  "status"
    t.boolean  "certified",         default: false
    t.string   "alternate_name"
    t.string   "legal_status"
  end

  create_table "reviews", force: :cascade do |t|
    t.text    "review"
    t.integer "rating_id", null: false
    t.index ["rating_id"], name: "index_reviews_on_rating_id", unique: true, using: :btree
  end

  create_table "schedule_days", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "day",         null: false
    t.integer  "opens_at"
    t.integer  "closes_at"
    t.integer  "schedule_id", null: false
    t.index ["schedule_id"], name: "index_schedule_days_on_schedule_id", using: :btree
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "resource_id"
    t.integer  "service_id"
    t.index ["resource_id"], name: "index_schedules_on_resource_id", using: :btree
    t.index ["service_id"], name: "index_schedules_on_service_id", using: :btree
  end

  create_table "services", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.text     "long_description"
    t.string   "eligibility"
    t.string   "required_documents"
    t.string   "fee"
    t.text     "application_process"
    t.integer  "resource_id"
    t.datetime "verified_at"
    t.string   "email"
    t.integer  "status"
    t.boolean  "certified",           default: false
    t.integer  "program_id"
    t.index ["program_id"], name: "index_services_on_program_id", using: :btree
    t.index ["resource_id"], name: "index_services_on_resource_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
  end

  add_foreign_key "addresses", "resources"
  add_foreign_key "change_requests", "resources"
  add_foreign_key "field_changes", "change_requests"
  add_foreign_key "notes", "resources"
  add_foreign_key "notes", "services"
  add_foreign_key "phones", "resources"
  add_foreign_key "programs", "resources"
  add_foreign_key "ratings", "resources"
  add_foreign_key "ratings", "services"
  add_foreign_key "ratings", "users"
  add_foreign_key "reviews", "ratings"
  add_foreign_key "schedule_days", "schedules"
  add_foreign_key "schedules", "resources"
  add_foreign_key "schedules", "services"
  add_foreign_key "services", "programs"
  add_foreign_key "services", "resources"
end
