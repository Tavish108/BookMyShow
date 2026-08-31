# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_29_180012) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "auditoria", force: :cascade do |t|
    t.integer "capacity", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "screen_type"
    t.bigint "theatre_id", null: false
    t.datetime "updated_at", null: false
    t.index ["theatre_id"], name: "index_auditoria_on_theatre_id"
  end

  create_table "genres", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "languages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "movie_genres", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "genre_id", null: false
    t.bigint "movie_id", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_movie_genres_on_genre_id"
    t.index ["movie_id"], name: "index_movie_genres_on_movie_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "certificate"
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.text "description"
    t.integer "duration_minutes"
    t.bigint "language_id", null: false
    t.string "poster_url"
    t.date "release_date"
    t.string "status"
    t.string "title"
    t.string "trailer_url"
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_movies_on_created_by_id"
    t.index ["language_id"], name: "index_movies_on_language_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "seats", force: :cascade do |t|
    t.bigint "auditorium_id", null: false
    t.datetime "created_at", null: false
    t.string "row_name", null: false
    t.string "seat_category"
    t.integer "seat_number", null: false
    t.string "seat_type"
    t.datetime "updated_at", null: false
    t.index ["auditorium_id", "row_name", "seat_number"], name: "index_seats_on_auditorium_id_and_row_name_and_seat_number", unique: true
    t.index ["auditorium_id"], name: "index_seats_on_auditorium_id"
  end

  create_table "theatres", force: :cascade do |t|
    t.string "address"
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.string "phone"
    t.string "postal_code"
    t.string "state"
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_theatres_on_city"
    t.index ["status"], name: "index_theatres_on_status"
  end

  create_table "user_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "role_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "email_verified_at"
    t.string "name"
    t.string "password_digest"
    t.string "phone"
    t.datetime "phone_verified_at"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "auditoria", "theatres"
  add_foreign_key "movie_genres", "genres"
  add_foreign_key "movie_genres", "movies"
  add_foreign_key "movies", "languages"
  add_foreign_key "movies", "users", column: "created_by_id"
  add_foreign_key "seats", "auditoria"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
