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

ActiveRecord::Schema.define(version: 2021_02_14_012211) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accessibilities", force: :cascade do |t|
    t.string "accessibility"
    t.string "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "addresses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attention"
    t.string "address_1", null: false
    t.string "address_2"
    t.string "address_3"
    t.string "address_4"
    t.string "city", null: false
    t.string "state_province", null: false
    t.string "postal_code", null: false
    t.string "country", null: false
    t.integer "resource_id"
    t.decimal "latitude"
    t.decimal "longitude"
    t.boolean "online"
    t.string "region"
    t.string "name"
    t.text "description"
    t.text "transportation"
    t.index ["resource_id"], name: "index_addresses_on_resource_id"
  end

  create_table "addresses_services", id: false, force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "address_id", null: false
    t.index ["address_id", "service_id"], name: "index_addresses_services_on_address_id_and_service_id"
    t.index ["service_id", "address_id"], name: "index_addresses_services_on_service_id_and_address_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email"
    t.index ["uid", "provider"], name: "index_admins_on_uid_and_provider", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.string "identifier"
    t.datetime "date_value"
    t.integer "id_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_bookmarks_on_identifier", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.boolean "top_level", default: false, null: false
    t.string "vocabulary"
    t.boolean "featured", default: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "categories_keywords", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "keyword_id", null: false
  end

  create_table "categories_resources", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "resource_id", null: false
    t.index ["category_id"], name: "index_categories_resources_on_category_id"
    t.index ["resource_id"], name: "index_categories_resources_on_resource_id"
  end

  create_table "categories_services", id: false, force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "category_id", null: false
    t.integer "feature_rank"
    t.index ["category_id"], name: "index_categories_services_on_category_id"
    t.index ["service_id"], name: "index_categories_services_on_service_id"
  end

  create_table "categories_sites", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "site_id", null: false
    t.index ["category_id"], name: "index_categories_sites_on_category_id"
    t.index ["site_id"], name: "index_categories_sites_on_site_id"
  end

  create_table "category_relationships", id: false, force: :cascade do |t|
    t.integer "parent_id", null: false
    t.integer "child_id", null: false
  end

  create_table "change_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.integer "object_id"
    t.integer "status", default: 0
    t.integer "action", default: 1
    t.integer "resource_id"
    t.index ["resource_id"], name: "index_change_requests_on_resource_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "resource_id"
    t.integer "service_id"
    t.index ["resource_id"], name: "index_contacts_on_resource_id"
    t.index ["service_id"], name: "index_contacts_on_service_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "eligibilities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "feature_rank"
    t.index ["feature_rank"], name: "index_eligibilities_on_feature_rank"
    t.index ["name"], name: "index_eligibilities_on_name", unique: true
  end

  create_table "eligibilities_services", id: false, force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "eligibility_id", null: false
    t.index ["eligibility_id"], name: "index_eligibilities_services_on_eligibility_id"
    t.index ["service_id"], name: "index_eligibilities_services_on_service_id"
  end

  create_table "field_changes", force: :cascade do |t|
    t.string "field_name"
    t.string "field_value"
    t.integer "change_request_id", null: false
    t.index ["change_request_id"], name: "index_field_changes_on_change_request_id"
  end

  create_table "fundings", force: :cascade do |t|
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keywords", force: :cascade do |t|
    t.string "name"
  end

  create_table "keywords_resources", id: false, force: :cascade do |t|
    t.integer "resource_id", null: false
    t.integer "keyword_id", null: false
  end

  create_table "keywords_services", id: false, force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "keyword_id", null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.text "note"
    t.integer "resource_id"
    t.integer "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_notes_on_resource_id"
    t.index ["service_id"], name: "index_notes_on_service_id"
  end

  create_table "phones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number", null: false
    t.string "service_type", null: false
    t.integer "resource_id", null: false
    t.string "description"
    t.integer "service_id"
    t.integer "contact_id"
    t.integer "language_id"
    t.index ["contact_id"], name: "index_phones_on_contact_id"
    t.index ["language_id"], name: "index_phones_on_language_id"
    t.index ["resource_id"], name: "index_phones_on_resource_id"
    t.index ["service_id"], name: "index_phones_on_service_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.string "alternate_name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "resource_id"
    t.index ["resource_id"], name: "index_programs_on_resource_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.decimal "rating"
    t.integer "user_id", null: false
    t.integer "resource_id"
    t.integer "service_id"
    t.index ["resource_id"], name: "index_ratings_on_resource_id"
    t.index ["service_id"], name: "index_ratings_on_service_id"
    t.index ["user_id", "resource_id", "service_id"], name: "index_ratings_on_user_id_and_resource_id_and_service_id", unique: true
    t.index ["user_id", "resource_id"], name: "index_ratings_on_user_id_and_resource_id", unique: true
    t.index ["user_id", "service_id"], name: "index_ratings_on_user_id_and_service_id", unique: true
  end

  create_table "resources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "short_description"
    t.text "long_description"
    t.string "website"
    t.datetime "verified_at"
    t.string "email"
    t.integer "status"
    t.boolean "certified", default: false
    t.string "alternate_name"
    t.string "legal_status"
    t.integer "contact_id"
    t.integer "funding_id"
    t.datetime "certified_at"
    t.boolean "featured"
    t.integer "source_attribution", default: 0
    t.index ["contact_id"], name: "index_resources_on_contact_id"
    t.index ["funding_id"], name: "index_resources_on_funding_id"
    t.index ["updated_at", "id"], name: "index_resources_on_updated_at_and_id"
  end

  create_table "resources_sites", id: false, force: :cascade do |t|
    t.bigint "resource_id", null: false
    t.bigint "site_id", null: false
    t.index ["resource_id"], name: "index_resources_sites_on_resource_id"
    t.index ["site_id"], name: "index_resources_sites_on_site_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "review"
    t.integer "rating_id", null: false
    t.index ["rating_id"], name: "index_reviews_on_rating_id", unique: true
  end

  create_table "schedule_days", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "day", null: false
    t.integer "opens_at"
    t.integer "closes_at"
    t.integer "schedule_id", null: false
    t.time "open_time"
    t.string "open_day"
    t.time "close_time"
    t.string "close_day"
    t.index ["schedule_id"], name: "index_schedule_days_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "resource_id"
    t.integer "service_id"
    t.boolean "hours_known", default: true
    t.index ["resource_id"], name: "index_schedules_on_resource_id"
    t.index ["service_id"], name: "index_schedules_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "long_description"
    t.string "eligibility"
    t.string "required_documents"
    t.string "fee"
    t.text "application_process"
    t.integer "resource_id"
    t.datetime "verified_at"
    t.string "email"
    t.integer "status"
    t.boolean "certified", default: false
    t.integer "program_id"
    t.string "interpretation_services"
    t.string "url"
    t.string "wait_time"
    t.integer "contact_id"
    t.integer "funding_id"
    t.string "alternate_name"
    t.datetime "certified_at"
    t.boolean "featured"
    t.integer "source_attribution", default: 0
    t.index ["contact_id"], name: "index_services_on_contact_id"
    t.index ["funding_id"], name: "index_services_on_funding_id"
    t.index ["program_id"], name: "index_services_on_program_id"
    t.index ["resource_id"], name: "index_services_on_resource_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "site_code", default: "sfsg"
  end

  create_table "synonym_groups", force: :cascade do |t|
    t.integer "group_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_type"], name: "index_synonym_groups_on_group_type"
  end

  create_table "synonyms", force: :cascade do |t|
    t.string "word"
    t.bigint "synonym_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["synonym_group_id"], name: "index_synonyms_on_synonym_group_id"
    t.index ["word"], name: "index_synonyms_on_word"
  end

  create_table "texting_recipients", force: :cascade do |t|
    t.string "recipient_name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "textings", force: :cascade do |t|
    t.bigint "texting_recipient_id", null: false
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_textings_on_service_id"
    t.index ["texting_recipient_id"], name: "index_textings_on_texting_recipient_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "volunteers", force: :cascade do |t|
    t.string "description"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "resource_id"
    t.index ["resource_id"], name: "index_volunteers_on_resource_id"
  end

  add_foreign_key "addresses", "resources"
  add_foreign_key "categories_sites", "categories"
  add_foreign_key "categories_sites", "sites"
  add_foreign_key "change_requests", "resources"
  add_foreign_key "contacts", "resources"
  add_foreign_key "contacts", "services"
  add_foreign_key "field_changes", "change_requests"
  add_foreign_key "notes", "resources"
  add_foreign_key "notes", "services"
  add_foreign_key "phones", "contacts"
  add_foreign_key "phones", "languages"
  add_foreign_key "phones", "resources"
  add_foreign_key "phones", "services"
  add_foreign_key "programs", "resources"
  add_foreign_key "ratings", "resources"
  add_foreign_key "ratings", "services"
  add_foreign_key "ratings", "users"
  add_foreign_key "resources", "contacts"
  add_foreign_key "resources", "fundings"
  add_foreign_key "resources_sites", "resources"
  add_foreign_key "resources_sites", "sites"
  add_foreign_key "reviews", "ratings"
  add_foreign_key "schedule_days", "schedules"
  add_foreign_key "schedules", "resources"
  add_foreign_key "schedules", "services"
  add_foreign_key "services", "contacts"
  add_foreign_key "services", "fundings"
  add_foreign_key "services", "programs"
  add_foreign_key "services", "resources"
  add_foreign_key "synonyms", "synonym_groups"
  add_foreign_key "textings", "services"
  add_foreign_key "textings", "texting_recipients"
  add_foreign_key "volunteers", "resources"
end
