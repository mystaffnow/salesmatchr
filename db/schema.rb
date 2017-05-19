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

ActiveRecord::Schema.define(version: 20170519071644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "answers", force: :cascade do |t|
    t.string   "name"
    t.integer  "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidate_job_actions", force: :cascade do |t|
    t.integer  "candidate_id"
    t.integer  "job_id"
    t.boolean  "is_saved"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "candidate_job_actions", ["candidate_id", "job_id"], name: "index_candidate_job_actions_on_candidate_id_and_job_id", unique: true, using: :btree
  add_index "candidate_job_actions", ["candidate_id"], name: "index_candidate_job_actions_on_candidate_id", using: :btree
  add_index "candidate_job_actions", ["job_id"], name: "index_candidate_job_actions_on_job_id", using: :btree

  create_table "candidate_profiles", force: :cascade do |t|
    t.integer  "candidate_id"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip"
    t.integer  "education_level_id"
    t.string   "ziggeo_token"
    t.boolean  "is_incognito",                 default: true
    t.string   "linkedin_picture_url"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "is_active_match_subscription", default: true
  end

  add_index "candidate_profiles", ["candidate_id"], name: "index_candidate_profiles_on_candidate_id", unique: true, using: :btree
  add_index "candidate_profiles", ["education_level_id"], name: "index_candidate_profiles_on_education_level_id", using: :btree
  add_index "candidate_profiles", ["state_id"], name: "index_candidate_profiles_on_state_id", using: :btree

  create_table "candidate_question_answers", force: :cascade do |t|
    t.integer  "candidate_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "candidate_question_answers", ["answer_id"], name: "index_candidate_question_answers_on_answer_id", using: :btree
  add_index "candidate_question_answers", ["candidate_id", "question_id"], name: "uniq_index_candidate_id_and_question_id", unique: true, using: :btree
  add_index "candidate_question_answers", ["candidate_id"], name: "index_candidate_question_answers_on_candidate_id", using: :btree
  add_index "candidate_question_answers", ["question_id"], name: "index_candidate_question_answers_on_question_id", using: :btree

  create_table "candidates", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "archetype_score"
    t.integer  "year_experience_id"
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
  end

  add_index "candidates", ["email"], name: "index_candidates_on_email", unique: true, using: :btree
  add_index "candidates", ["reset_password_token"], name: "index_candidates_on_reset_password_token", unique: true, using: :btree
  add_index "candidates", ["year_experience_id"], name: "index_candidates_on_year_experience_id", using: :btree

  create_table "colleges", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "employer_id"
    t.string   "stripe_card_token"
    t.string   "stripe_customer_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "last4"
    t.string   "card_holder_name"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.boolean  "is_selected",        default: false
  end

  add_index "customers", ["employer_id"], name: "index_customers_on_employer_id", using: :btree

  create_table "education_levels", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "educations", force: :cascade do |t|
    t.integer  "college_id"
    t.string   "college_other"
    t.integer  "education_level_id"
    t.string   "description"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "candidate_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "educations", ["candidate_id"], name: "index_educations_on_candidate_id", using: :btree
  add_index "educations", ["college_id"], name: "index_educations_on_college_id", using: :btree
  add_index "educations", ["education_level_id"], name: "index_educations_on_education_level_id", using: :btree

  create_table "employer_profiles", force: :cascade do |t|
    t.integer  "employer_id"
    t.string   "website"
    t.string   "ziggeo_token"
    t.string   "zip"
    t.string   "city"
    t.integer  "state_id"
    t.string   "description"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "employer_profiles", ["employer_id"], name: "index_employer_profiles_on_employer_id", unique: true, using: :btree
  add_index "employer_profiles", ["state_id"], name: "index_employer_profiles_on_state_id", using: :btree

  create_table "employers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
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

  add_index "experiences", ["candidate_id"], name: "index_experiences_on_candidate_id", using: :btree
  add_index "experiences", ["sales_type_id"], name: "index_experiences_on_sales_type_id", using: :btree

  create_table "job_candidates", force: :cascade do |t|
    t.integer  "candidate_id"
    t.integer  "job_id"
    t.integer  "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "job_candidates", ["candidate_id", "job_id"], name: "index_job_candidates_on_candidate_id_and_job_id", unique: true, using: :btree
  add_index "job_candidates", ["candidate_id"], name: "index_job_candidates_on_candidate_id", using: :btree
  add_index "job_candidates", ["job_id"], name: "index_job_candidates_on_job_id", using: :btree

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
    t.string   "zip"
    t.boolean  "is_remote"
    t.string   "title"
    t.text     "description"
    t.integer  "state_id"
    t.string   "city"
    t.integer  "archetype_low"
    t.integer  "archetype_high"
    t.integer  "job_function_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "experience_years"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "status",           default: 0
    t.boolean  "is_active",        default: false
    t.datetime "activated_at"
  end

  add_index "jobs", ["employer_id"], name: "index_jobs_on_employer_id", using: :btree
  add_index "jobs", ["job_function_id"], name: "index_jobs_on_job_function_id", using: :btree
  add_index "jobs", ["state_id"], name: "index_jobs_on_state_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "employer_id"
    t.integer  "job_id"
    t.decimal  "amount",           precision: 18, scale: 4
    t.string   "stripe_charge_id"
    t.integer  "status"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "customer_id"
  end

  add_index "payments", ["customer_id"], name: "index_payments_on_customer_id", using: :btree
  add_index "payments", ["employer_id"], name: "index_payments_on_employer_id", using: :btree
  add_index "payments", ["job_id"], name: "index_payments_on_job_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "year_experiences", force: :cascade do |t|
    t.string   "name"
    t.integer  "low"
    t.integer  "high"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
