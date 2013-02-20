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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130218211250) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "answer"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "correct"
  end

  create_table "completions", :force => true do |t|
    t.integer  "subsection_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "courses", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "teacher_id"
    t.string   "category"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "questions", :force => true do |t|
    t.integer  "subsection_id"
    t.integer  "section_id"
    t.text     "prompt"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "correct_answer_id"
    t.string   "free_answer"
    t.boolean  "multiple_choice"
    t.string   "answer_prefix"
    t.string   "answer_suffix"
  end

  create_table "sections", :force => true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  create_table "subsections", :force => true do |t|
    t.integer  "section_id"
    t.integer  "course_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_answers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.string   "free_answer"
    t.integer  "attempts"
    t.integer  "last_answer_id"
    t.boolean  "correct"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
