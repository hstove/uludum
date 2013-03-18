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

ActiveRecord::Schema.define(version: 20130318212102) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.text     "answer"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "correct"
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
    t.string   "category"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "hidden"
  end

  create_table "enrollments", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "sections", force: true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
  end

  create_table "subsections", force: true do |t|
    t.integer  "section_id"
    t.integer  "course_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.text     "teacher_description"
    t.text     "about_me"
    t.string   "avatar_url"
  end

  create_table "wish_votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "wish_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wishes", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
