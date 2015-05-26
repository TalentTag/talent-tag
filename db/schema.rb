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

ActiveRecord::Schema.define(version: 20150523142013) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "btree_gist"
  enable_extension "pg_trgm"

  create_table "areas", force: true do |t|
    t.string "name"
  end

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "entry_id"
    t.text     "text",       null: false
    t.datetime "created_at"
    t.integer  "company_id", null: false
  end

  add_index "comments", ["company_id"], name: "index_comments_on_company_id", using: :btree

  create_table "companies", force: true do |t|
    t.string   "name",          limit: 30,              null: false
    t.integer  "owner_id"
    t.string   "website",       limit: 40
    t.string   "phone",         limit: 20
    t.string   "address"
    t.string   "details"
    t.date     "confirmed_at"
    t.datetime "created_at",                            null: false
    t.datetime "premium_since"
    t.datetime "premium_until"
    t.json     "social",                   default: {}
  end

  add_index "companies", ["name"], name: "index_companies_on_name", using: :btree

  create_table "conversations", force: true do |t|
    t.integer  "participants",                              array: true
    t.datetime "last_message_at"
    t.integer  "user_id",                      null: false
    t.integer  "specialist_id",                null: false
    t.json     "last_activity",   default: {}
  end

  create_table "entries", id: false, force: true do |t|
    t.integer  "id",                                              null: false
    t.text     "body",                                            null: false
    t.integer  "source_id"
    t.string   "url"
    t.datetime "created_at",                                      null: false
    t.json     "author"
    t.datetime "fetched_at",                                      null: false
    t.integer  "user_id"
    t.integer  "duplicate_of"
    t.string   "state",                        default: "normal"
    t.string   "profile_location", limit: 100
    t.integer  "location_id"
  end

  add_index "entries", ["id"], name: "index_entries_on_id", unique: true, using: :btree
  add_index "entries", ["profile_location"], name: "index_entries_on_profile_location", using: :gist
  add_index "entries", ["source_id"], name: "index_entries_on_source_id", using: :btree
  add_index "entries", ["user_id"], name: "index_entries_on_user_id", using: :btree

  create_table "folders", force: true do |t|
    t.string  "name"
    t.integer "user_id"
    t.string  "entries", default: [], array: true
  end

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider",              null: false
    t.string   "uid",                   null: false
    t.datetime "created_at"
    t.string   "anchor",     limit: 70
    t.json     "raw_data"
  end

  add_index "identities", ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true, using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "industries", force: true do |t|
    t.string "name"
  end

  create_table "invites", force: true do |t|
    t.string  "code",       null: false
    t.string  "email",      null: false
    t.integer "company_id", null: false
  end

  create_table "keyword_groups", force: true do |t|
    t.string  "keywords",    array: true
    t.integer "industry_id"
    t.integer "area_id"
    t.string  "exceptions",  array: true
  end

  add_index "keyword_groups", ["exceptions"], name: "index_keyword_groups_on_exceptions", using: :gin
  add_index "keyword_groups", ["keywords"], name: "index_keyword_groups_on_keywords", using: :gin

  create_table "locations", force: true do |t|
    t.string "name",     null: false
    t.string "synonyms", null: false, array: true
  end

  create_table "media", force: true do |t|
    t.string "title",        null: false
    t.string "source",       null: false
    t.string "link",         null: false
    t.date   "published_at"
    t.string "tags",                      array: true
  end

  create_table "messages", force: true do |t|
    t.integer  "conversation_id"
    t.integer  "user_id",         null: false
    t.text     "text",            null: false
    t.datetime "created_at"
    t.string   "source",          null: false
  end

  create_table "notifications", force: true do |t|
    t.string   "source",     null: false
    t.integer  "author_id",  null: false
    t.string   "event",      null: false
    t.json     "data"
    t.datetime "created_at", null: false
  end

  add_index "notifications", ["source", "author_id"], name: "index_notifications_on_source_and_author_id", using: :btree

  create_table "payments", force: true do |t|
    t.integer  "plan_id"
    t.integer  "company_id"
    t.string   "identifier"
    t.string   "state"
    t.datetime "confirmed_at"
    t.datetime "completed_at"
    t.datetime "canceled_at"
    t.datetime "failed_at"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "portfolio", force: true do |t|
    t.integer  "user_id"
    t.string   "title",      null: false
    t.string   "href",       null: false
    t.datetime "created_at", null: false
  end

  create_table "proposals", force: true do |t|
    t.integer  "company_id"
    t.string   "status",     limit: 10, default: "awaiting"
    t.string   "note"
    t.datetime "created_at",                                 null: false
  end

  create_table "queries", force: true do |t|
    t.string   "text",       null: false
    t.integer  "user_id"
    t.datetime "created_at"
  end

  create_table "searches", force: true do |t|
    t.string   "name"
    t.string   "query"
    t.integer  "user_id"
    t.string   "blacklisted",     default: [], array: true
    t.datetime "last_checked_at"
    t.json     "filters",         default: {}
  end

  create_table "sources", id: false, force: true do |t|
    t.integer "id",                     null: false
    t.string  "name",                   null: false
    t.string  "url"
    t.boolean "hidden", default: false
  end

  add_index "sources", ["id"], name: "index_sources_on_id", unique: true, using: :btree

  create_table "specialists", force: true do |t|
    t.string   "email",            limit: 60,                     null: false
    t.string   "password_digest",                                 null: false
    t.string   "firstname",        limit: 30
    t.string   "lastname",         limit: 30
    t.json     "profile",                     default: {}
    t.string   "status",                      default: "passive"
    t.string   "tags",                        default: [],                     array: true
    t.string   "role"
    t.string   "forgot_token"
    t.string   "auth_token"
    t.datetime "last_login_at"
    t.date     "created_at",                                      null: false
    t.boolean  "can_login",                   default: true
    t.string   "profile_location"
    t.integer  "location_id"
  end

  add_index "specialists", ["email"], name: "index_specialists_on_email", unique: true, using: :btree
  add_index "specialists", ["location_id"], name: "index_specialists_on_location_id", using: :btree
  add_index "specialists", ["profile_location"], name: "index_specialists_on_profile_location", using: :gist

  create_table "specialists_users", force: true do |t|
    t.integer "user_id"
    t.integer "specialist_id"
  end

  add_index "specialists_users", ["user_id"], name: "index_specialists_users_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",           limit: 60,              null: false
    t.string   "password_digest",                         null: false
    t.integer  "company_id"
    t.string   "firstname",       limit: 30
    t.string   "lastname",        limit: 30
    t.string   "phone",           limit: 20
    t.string   "note"
    t.string   "forgot_token"
    t.string   "auth_token"
    t.date     "created_at",                              null: false
    t.string   "role"
    t.datetime "last_login_at"
    t.json     "profile",                    default: {}
    t.json     "settings",                   default: {}
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
