# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_24_071453) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "avatars", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "image_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_avatars_on_user_id", unique: true
  end

  create_table "choices", force: :cascade do |t|
    t.string "body", null: false
    t.boolean "correctness", default: false, null: false
    t.bigint "quiz_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["quiz_id"], name: "index_choices_on_quiz_id"
  end

  create_table "queries", force: :cascade do |t|
    t.string "body", null: false
    t.bigint "quiz_id", null: false
    t.string "answer", null: false
    t.integer "revealed_point", default: 0, null: false
    t.integer "point", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "category", default: 0, null: false
    t.index ["quiz_id"], name: "index_queries_on_quiz_id"
  end

  create_table "query_statuses", force: :cascade do |t|
    t.bigint "query_id", null: false
    t.bigint "quiz_status_id", null: false
    t.index ["query_id", "quiz_status_id"], name: "index_query_statuses_on_query_id_and_quiz_status_id", unique: true
    t.index ["query_id"], name: "index_query_statuses_on_query_id"
    t.index ["quiz_status_id"], name: "index_query_statuses_on_quiz_status_id"
  end

  create_table "quiz_statuses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "quiz_id", null: false
    t.integer "total_points", default: 0, null: false
    t.integer "query_times", default: 0, null: false
    t.boolean "be_solved", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "failed_answer_times", default: 0, null: false
    t.index ["quiz_id", "user_id"], name: "index_quiz_statuses_on_quiz_id_and_user_id", unique: true
    t.index ["quiz_id"], name: "index_quiz_statuses_on_quiz_id"
    t.index ["user_id"], name: "index_quiz_statuses_on_user_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "title", null: false
    t.string "question", null: false
    t.bigint "user_id", null: false
    t.string "answer", null: false
    t.integer "difficulity", default: 5, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "published", default: 0, null: false
    t.text "image_data"
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "level", default: 1, null: false
    t.string "description", default: "", null: false
    t.string "uid"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "avatars", "users"
  add_foreign_key "choices", "quizzes"
  add_foreign_key "queries", "quizzes"
  add_foreign_key "query_statuses", "queries"
  add_foreign_key "query_statuses", "quiz_statuses"
  add_foreign_key "quiz_statuses", "quizzes"
  add_foreign_key "quiz_statuses", "users"
  add_foreign_key "quizzes", "users"
end
