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

ActiveRecord::Schema.define(version: 20150408041315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "candidate_job_actions", force: :cascade do |t|
    t.integer  "candidate_id"
    t.integer  "job_id"
    t.boolean  "is_saved"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "candidates", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip"
    t.integer  "education_level_id"
    t.integer  "archetype_score"
    t.string   "ziggeo_token"
    t.string   "uid"
    t.string   "provider"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "candidates", ["email"], name: "index_candidates_on_email", unique: true, using: :btree
  add_index "candidates", ["reset_password_token"], name: "index_candidates_on_reset_password_token", unique: true, using: :btree

  create_table "education_levels", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "educations", force: :cascade do |t|
    t.string   "school"
    t.integer  "education_level_id"
    t.string   "description"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "candidate_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "employers", force: :cascade do |t|
    t.string   "name"
    t.string   "company"
    t.integer  "state_id"
    t.string   "city"
    t.string   "zip"
    t.string   "description"
    t.string   "ziggeo_token"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "employers", ["email"], name: "index_employers_on_email", unique: true, using: :btree
  add_index "employers", ["reset_password_token"], name: "index_employers_on_reset_password_token", unique: true, using: :btree

  create_table "experiences", force: :cascade do |t|
    t.string   "position"
    t.string   "company"
    t.string   "description"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "is_current"
    t.boolean  "is_sales"
    t.integer  "sales_type_id"
    t.integer  "candidate_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "job_candidates", force: :cascade do |t|
    t.integer  "candidate_id"
    t.integer  "job_id"
    t.integer  "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "job_functions", force: :cascade do |t|
    t.string   "name"
    t.integer  "low"
    t.integer  "high"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.integer  "employer_id"
    t.integer  "salary_low"
    t.integer  "salary_high"
    t.integer  "zip"
    t.boolean  "is_remote"
    t.string   "title"
    t.text     "description"
    t.boolean  "is_active",      default: false
    t.integer  "view_count"
    t.integer  "state_id"
    t.string   "city"
    t.integer  "archetype_low"
    t.integer  "archetype_high"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "sales_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
