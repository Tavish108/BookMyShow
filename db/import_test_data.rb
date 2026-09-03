require "csv"

class TestDataImporter
  DATA_DIR = Rails.root.join("db", "test_data")

  def self.run
    new.run
  end

  def run
    puts "\n🚀 Starting BookMyShow test-data import..."
    puts "Data directory: #{DATA_DIR}\n\n"

    ActiveRecord::Base.transaction do
      import_roles
      import_users
      import_user_roles

      import_languages
      import_genres

      import_theatres
      import_auditoria
      import_seats

      import_movies
      import_movie_genres

      import_shows
      import_show_seats

      import_bookings
      import_booking_seats

      import_payments
      import_tickets

      synchronize_show_seat_statuses
    end

    puts "\n✅ Test data imported successfully!"
  rescue StandardError => e
    puts "\n❌ Import failed!"
    puts "#{e.class}: #{e.message}"
    puts "\nNo changes were committed because the import runs inside a transaction."
    puts e.backtrace.first(10).join("\n")
    raise
  end

  private

  def csv(name)
    path = DATA_DIR.join("#{name}.csv")

    unless File.exist?(path)
      raise "CSV file not found: #{path}"
    end

    CSV.read(path, headers: true)
  end

  def import_roles
    puts "Importing roles..."

    csv("roles").each do |row|
      Role.create!(
        id: row["id"],
        name: row["name"]
      )
    end

    puts "  ✓ #{Role.count} roles"
  end

  def import_users
    puts "Importing users..."

    csv("users").each do |row|
      user = User.new(
        id: row["id"],
        name: row["name"],
        email: row["email"],
        phone: row["phone"],
        email_verified_at: row["email_verified_at"],
        phone_verified_at: row["phone_verified_at"]
      )

      # CSV intentionally does not contain bcrypt password digests.
      # has_secure_password generates the digest here.
      user.password = "Test@12345"
      user.password_confirmation = "Test@12345"

      user.save!
    end

    puts "  ✓ #{User.count} users"
    puts "  ✓ Password for test users: Test@12345"
  end

  def import_user_roles
    puts "Importing user roles..."

    csv("user_roles").each do |row|
      UserRole.create!(
        id: row["id"],
        user_id: row["user_id"],
        role_id: row["role_id"]
      )
    end

    puts "  ✓ #{UserRole.count} user-role assignments"
  end

  def import_languages
    puts "Importing languages..."

    csv("languages").each do |row|
      Language.create!(
        id: row["id"],
        name: row["name"]
      )
    end

    puts "  ✓ #{Language.count} languages"
  end

  def import_genres
    puts "Importing genres..."

    csv("genres").each do |row|
      Genre.create!(
        id: row["id"],
        name: row["name"]
      )
    end

    puts "  ✓ #{Genre.count} genres"
  end

  def import_theatres
    puts "Importing theatres..."

    csv("theatres").each do |row|
      Theatre.create!(
        id: row["id"],
        name: row["name"],
        address: row["address"],
        city: row["city"],
        state: row["state"],
        postal_code: row["postal_code"],
        phone: row["phone"],
        email: row["email"],
        status: row["status"],
        created_by_id: row["created_by_id"]
      )
    end

    puts "  ✓ #{Theatre.count} theatres"
  end

  def import_auditoria
    puts "Importing auditoria..."

    csv("auditoria").each do |row|
      Auditorium.create!(
        id: row["id"],
        name: row["name"],
        capacity: row["capacity"],
        screen_type: row["screen_type"],
        theatre_id: row["theatre_id"]
      )
    end

    puts "  ✓ #{Auditorium.count} auditoria"
  end

  def import_seats
    puts "Importing seats..."

    csv("seats").each do |row|
      Seat.create!(
        id: row["id"],
        row_name: row["row_name"],
        seat_number: row["seat_number"],
        seat_type: row["seat_type"],
        seat_category: row["seat_category"],
        auditorium_id: row["auditorium_id"]
      )
    end

    puts "  ✓ #{Seat.count} seats"
  end

  def import_movies
    puts "Importing movies..."

    csv("movies").each do |row|
      Movie.create!(
        id: row["id"],
        title: row["title"],
        description: row["description"],
        duration_minutes: row["duration_minutes"],
        certificate: row["certificate"],
        release_date: row["release_date"],
        poster_url: row["poster_url"],
        trailer_url: row["trailer_url"],
        status: row["status"],
        language_id: row["language_id"],
        created_by_id: row["created_by_id"]
      )
    end

    puts "  ✓ #{Movie.count} movies"
  end

  def import_movie_genres
    puts "Importing movie genres..."

    csv("movie_genres").each do |row|
      MovieGenre.create!(
        id: row["id"],
        movie_id: row["movie_id"],
        genre_id: row["genre_id"]
      )
    end

    puts "  ✓ #{MovieGenre.count} movie-genre assignments"
  end

  def import_shows
    puts "Importing shows..."

    csv("shows").each do |row|
      Show.create!(
        id: row["id"],
        movie_id: row["movie_id"],
        theatre_id: row["theatre_id"],
        auditorium_id: row["auditorium_id"],
        show_date: row["show_date"],
        start_time: row["start_time"],
        end_time: row["end_time"],
        price: row["price"],
        status: row["status"]
      )
    end

    puts "  ✓ #{Show.count} shows"
  end

  def import_show_seats
    puts "Importing show seats..."

    csv("show_seats").each do |row|
      ShowSeat.create!(
        id: row["id"],
        show_id: row["show_id"],
        seat_id: row["seat_id"],
        status: row["status"],
        held_until: row["held_until"]
      )
    end

    puts "  ✓ #{ShowSeat.count} show seats"
  end

  def import_bookings
    puts "Importing bookings..."

    csv("bookings").each do |row|
      Booking.create!(
        id: row["id"],
        user_id: row["user_id"],
        show_id: row["show_id"],
        status: row["status"],
        total_amount: row["total_amount"],
        expires_at: row["expires_at"]
      )
    end

    puts "  ✓ #{Booking.count} bookings"
  end

  def import_booking_seats
    puts "Importing booking seats..."

    csv("booking_seats").each do |row|
      BookingSeat.create!(
        id: row["id"],
        booking_id: row["booking_id"],
        show_seat_id: row["show_seat_id"],
        price: row["price"]
      )
    end

    puts "  ✓ #{BookingSeat.count} booking seats"
  end

  def import_payments
    puts "Importing payments..."

    csv("payments").each do |row|
      Payment.create!(
        id: row["id"],
        booking_id: row["booking_id"],
        status: row["status"],
        payment_method: row["payment_method"],
        transaction_id: row["transaction_id"],
        amount: row["amount"],
        paid_at: row["paid_at"],
        razorpay_order_id: row["razorpay_order_id"],
        razorpay_signature: row["razorpay_signature"]
      )
    end

    puts "  ✓ #{Payment.count} payments"
  end

  def import_tickets
    puts "Importing tickets..."

    csv("tickets").each do |row|
      Ticket.create!(
        id: row["id"],
        booking_id: row["booking_id"],
        ticket_number: row["ticket_number"],
        qr_token: row["qr_token"]
      )
    end

    puts "  ✓ #{Ticket.count} tickets"
  end

  def synchronize_show_seat_statuses
    puts "Synchronizing booked show seats..."

    Booking
      .where(status: "CONFIRMED")
      .includes(:booking_seats)
      .find_each do |booking|

      booking.booking_seats.each do |booking_seat|
        show_seat = ShowSeat.find(booking_seat.show_seat_id)

        show_seat.update!(
          status: "BOOKED",
          held_until: nil
        )
      end
    end

    puts "  ✓ Confirmed booking seats marked as BOOKED"
  end
end

TestDataImporter.run
