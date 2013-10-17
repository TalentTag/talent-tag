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

ActiveRecord::Schema.define(version: 20131016195446) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: true do |t|
    t.string  "name",         limit: 30, null: false
    t.integer "owner_id"
    t.string  "website",      limit: 40
    t.string  "phone",        limit: 20
    t.string  "address"
    t.string  "details"
    t.date    "confirmed_at"
    t.date    "created_at",              null: false
  end

  add_index "companies", ["name"], name: "index_companies_on_name", using: :btree

  create_table "users", force: true do |t|
    t.string  "email",           limit: 60, null: false
    t.string  "password_digest",            null: false
    t.integer "company_id"
    t.string  "firstname",       limit: 30
    t.string  "midname",         limit: 30
    t.string  "lastname",        limit: 30
    t.string  "phone",           limit: 20
    t.string  "note"
    t.string  "forgot_token"
    t.string  "auth_token"
    t.date    "created_at",                 null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
