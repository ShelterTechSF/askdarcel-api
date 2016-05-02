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

ActiveRecord::Schema.define(version: 20160427223914) do

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
  end

  add_index "addresses", ["resource_id"], name: "index_addresses_on_resource_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name",       null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "categories_resources", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "resource_id", null: false
  end

  add_index "categories_resources", ["category_id"], name: "index_categories_resources_on_category_id", using: :btree
  add_index "categories_resources", ["resource_id"], name: "index_categories_resources_on_resource_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.text     "note"
    t.integer  "resource_id"
    t.integer  "service_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "notes", ["resource_id"], name: "index_notes_on_resource_id", using: :btree
  add_index "notes", ["service_id"], name: "index_notes_on_service_id", using: :btree

  create_table "phones", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "number",       null: false
    t.string   "extension"
    t.string   "service_type", null: false
    t.string   "country_code", null: false
    t.integer  "resource_id",  null: false
  end

  add_index "phones", ["resource_id"], name: "index_phones_on_resource_id", using: :btree

  create_table "resources", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "name",              null: false
    t.string   "short_description"
    t.text     "long_description"
    t.string   "website"
  end

  create_table "schedule_days", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "day",         null: false
    t.integer  "opens_at",    null: false
    t.integer  "closes_at",   null: false
    t.integer  "schedule_id", null: false
  end

  add_index "schedule_days", ["schedule_id"], name: "index_schedule_days_on_schedule_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "resource_id"
    t.integer  "service_id"
  end

  add_index "schedules", ["resource_id"], name: "index_schedules_on_resource_id", using: :btree
  add_index "schedules", ["service_id"], name: "index_schedules_on_service_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "name"
    t.text     "long_description"
    t.string   "eligibility"
    t.string   "required_documents"
    t.decimal  "fee"
    t.text     "application_process"
    t.integer  "resource_id"
  end

  add_index "services", ["resource_id"], name: "index_services_on_resource_id", using: :btree

  add_foreign_key "addresses", "resources"
  add_foreign_key "notes", "resources"
  add_foreign_key "notes", "services"
  add_foreign_key "phones", "resources"
  add_foreign_key "schedule_days", "schedules"
  add_foreign_key "schedules", "resources"
  add_foreign_key "schedules", "services"
  add_foreign_key "services", "resources"
end
