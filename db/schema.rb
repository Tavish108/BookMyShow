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

ActiveRecord::Schema[8.1].define(version: 2026_09_02_100218) do
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

  create_table "booking_seats", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.datetime "created_at", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.bigint "show_seat_id", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id", "show_seat_id"], name: "index_booking_seats_on_booking_id_and_show_seat_id", unique: true
    t.index ["booking_id"], name: "index_booking_seats_on_booking_id"
    t.index ["show_seat_id"], name: "index_booking_seats_on_show_seat_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.bigint "show_id", null: false
    t.string "status", default: "PENDING", null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["expires_at"], name: "index_bookings_on_expires_at"
    t.index ["show_id"], name: "index_bookings_on_show_id"
    t.index ["status"], name: "index_bookings_on_status"
    t.index ["user_id"], name: "index_bookings_on_user_id"
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

  create_table "payments", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "booking_id", null: false
    t.datetime "created_at", null: false
    t.datetime "paid_at"
    t.string "payment_method"
    t.string "razorpay_order_id"
    t.string "razorpay_signature"
    t.string "status", default: "PENDING", null: false
    t.string "transaction_id"
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
    t.index ["razorpay_order_id"], name: "index_payments_on_razorpay_order_id", unique: true
    t.index ["status"], name: "index_payments_on_status"
    t.index ["transaction_id"], name: "index_payments_on_transaction_id", unique: true
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

  create_table "show_seats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "held_until"
    t.bigint "seat_id", null: false
    t.bigint "show_id", null: false
    t.string "status", default: "AVAILABLE", null: false
    t.datetime "updated_at", null: false
    t.index ["held_until"], name: "index_show_seats_on_held_until"
    t.index ["seat_id"], name: "index_show_seats_on_seat_id"
    t.index ["show_id", "seat_id"], name: "index_show_seats_on_show_id_and_seat_id", unique: true
    t.index ["show_id"], name: "index_show_seats_on_show_id"
    t.index ["status"], name: "index_show_seats_on_status"
  end

  create_table "shows", force: :cascade do |t|
    t.bigint "auditorium_id", null: false
    t.datetime "created_at", null: false
    t.time "end_time", null: false
    t.bigint "movie_id", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.date "show_date", null: false
    t.time "start_time", null: false
    t.string "status", null: false
    t.bigint "theatre_id", null: false
    t.datetime "updated_at", null: false
    t.index ["auditorium_id"], name: "index_shows_on_auditorium_id"
    t.index ["movie_id"], name: "index_shows_on_movie_id"
    t.index ["theatre_id"], name: "index_shows_on_theatre_id"
  end

  create_table "theatres", force: :cascade do |t|
    t.string "address"
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.string "email"
    t.string "name", null: false
    t.string "phone"
    t.string "postal_code"
    t.string "state"
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_theatres_on_city"
    t.index ["created_by_id"], name: "index_theatres_on_created_by_id"
    t.index ["status"], name: "index_theatres_on_status"
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.datetime "created_at", null: false
    t.string "qr_token", null: false
    t.string "ticket_number", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_tickets_on_booking_id", unique: true
    t.index ["qr_token"], name: "index_tickets_on_qr_token", unique: true
    t.index ["ticket_number"], name: "index_tickets_on_ticket_number", unique: true
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

  create_table "verification_otps", force: :cascade do |t|
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "otp_digest", null: false
    t.string "purpose", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.datetime "verified_at"
    t.index ["expires_at"], name: "index_verification_otps_on_expires_at"
    t.index ["purpose"], name: "index_verification_otps_on_purpose"
    t.index ["user_id"], name: "index_verification_otps_on_user_id"
  end

  add_foreign_key "auditoria", "theatres"
  add_foreign_key "booking_seats", "bookings"
  add_foreign_key "booking_seats", "show_seats"
  add_foreign_key "bookings", "shows"
  add_foreign_key "bookings", "users"
  add_foreign_key "movie_genres", "genres"
  add_foreign_key "movie_genres", "movies"
  add_foreign_key "movies", "languages"
  add_foreign_key "movies", "users", column: "created_by_id"
  add_foreign_key "payments", "bookings"
  add_foreign_key "seats", "auditoria"
  add_foreign_key "show_seats", "seats"
  add_foreign_key "show_seats", "shows"
  add_foreign_key "shows", "auditoria"
  add_foreign_key "shows", "movies"
  add_foreign_key "shows", "theatres"
  add_foreign_key "theatres", "users", column: "created_by_id"
  add_foreign_key "tickets", "bookings"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "verification_otps", "users"
end
