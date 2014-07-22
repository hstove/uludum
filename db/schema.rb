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

ActiveRecord::Schema.define(version: 20140407004410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "afterparty_jobs", force: true do |t|
    t.text     "job_dump"
    t.string   "queue"
    t.datetime "execute_at"
    t.boolean  "completed"
    t.boolean  "has_error"
    t.text     "error_message"
    t.text     "error_backtrace"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.text     "answer"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "correct"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "supercategory"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "courses_count"
  end

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "completions", force: true do |t|
    t.integer  "subsection_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "courses", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "teacher_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "hidden"
    t.float    "price"
    t.string   "slug"
    t.integer  "category_id"
    t.string   "category_name"
    t.integer  "questions_count"
    t.boolean  "approved"
    t.string   "banner_url"
  end

  create_table "discussions", force: true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "discussable_type"
    t.integer  "discussable_id"
  end

  create_table "enrollments", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "funds", force: true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.float    "goal"
    t.datetime "goal_date"
    t.boolean  "hidden"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "course_id"
  end

  create_table "orders", force: true do |t|
    t.string   "orderable_type"
    t.integer  "orderable_id"
    t.string   "uuid"
    t.integer  "user_id"
    t.string   "status"
    t.string   "token"
    t.float    "price"
    t.string   "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expiration"
    t.string   "stripe_customer_id"
    t.string   "stripe_charge_id"
    t.string   "coinbase_id"
    t.string   "state"
    t.text     "error"
    t.string   "coinbase_code"
    t.float    "bitcoin_amount"
    t.string   "bitcoin_payout_address"
  end

  create_table "progresses", force: true do |t|
    t.string   "progressable_type"
    t.integer  "progressable_id"
    t.float    "percent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "questions", force: true do |t|
    t.integer  "subsection_id"
    t.integer  "section_id"
    t.text     "prompt"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "correct_answer_id"
    t.string   "free_answer"
    t.boolean  "multiple_choice"
    t.string   "answer_prefix"
    t.string   "answer_suffix"
    t.integer  "course_id"
    t.integer  "position"
  end

  create_table "rates", force: true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "stars",         null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type", using: :btree
  add_index "rates", ["rater_id"], name: "index_rates_on_rater_id", using: :btree

  create_table "rating_caches", force: true do |t|
    t.integer  "cacheable_id"
    t.string   "cacheable_type"
    t.float    "avg",            null: false
    t.integer  "qty",            null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rating_caches", ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type", using: :btree

  create_table "sections", force: true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
  end

  create_table "stripe_customers", force: true do |t|
    t.integer  "teacher_id"
    t.integer  "user_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subsections", force: true do |t|
    t.integer  "section_id"
    t.integer  "course_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "position"
    t.boolean  "previewable"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "updates", force: true do |t|
    t.string   "updateable_type"
    t.integer  "updateable_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_answers", force: true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.string   "free_answer"
    t.integer  "attempts"
    t.integer  "last_answer_id"
    t.boolean  "correct"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "teacher_description"
    t.text     "about_me"
    t.string   "avatar_url"
    t.string   "recipient_token"
    t.string   "refund_token"
    t.datetime "last_login"
    t.datetime "last_login_attempt"
    t.boolean  "show_email"
    t.boolean  "admin"
    t.string   "stripe_key"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "stripe_customer_id"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "bitcoin_address"
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "wish_votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "wish_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "willingness_to_pay"
  end

  create_table "wishes", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
