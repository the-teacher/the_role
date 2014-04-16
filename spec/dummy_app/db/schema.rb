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

ActiveRecord::Schema.define(version: 20120314061307) do

  create_table "pages", force: true do |t|
    t.integer  "user_id"
    t.integer  "person_id"
    t.string   "title"
    t.text     "content"
    t.string   "state",      default: "draft"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name",        default: ""
    t.string   "title",       default: ""
    t.text     "description"
    t.text     "the_role",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "company"
    t.string   "address"
    t.string   "some_protected_field",   default: "should_not_be_changed"
    t.string   "email",                  default: "",                      null: false
    t.string   "encrypted_password",     default: "",                      null: false
    t.string   "password",               default: "",                      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "role_id"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
