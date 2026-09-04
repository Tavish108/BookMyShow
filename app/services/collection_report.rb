class CollectionReport
  class << self

    # =========================================================
    # THEATRE ADMIN
    # =========================================================

    def for_theatre(theatre)
      show_ids = theatre.shows.select(:id)

      confirmed_bookings = Booking.where(
        show_id: show_ids,
        status: "CONFIRMED"
      )

      successful_payments = Payment.joins(:booking).where(
        bookings: {
          show_id: show_ids,
          status: "CONFIRMED"
        },
        status: "SUCCESS"
      )

      {
        bookings: confirmed_bookings.count,
        tickets: confirmed_bookings.joins(:booking_seats).count,
        collection: successful_payments.sum(:amount),
        auditoriums: auditorium_breakdown(theatre),
        movies: movie_breakdown_for_theatre(theatre)
      }
    end


    # =========================================================
    # AUDITORIUM REPORT
    # =========================================================

    def for_auditorium(auditorium)
      show_ids = auditorium.shows.select(:id)

      confirmed_bookings = Booking.where(
        show_id: show_ids,
        status: "CONFIRMED"
      )

      successful_payments = Payment.joins(:booking).where(
        bookings: {
          show_id: show_ids,
          status: "CONFIRMED"
        },
        status: "SUCCESS"
      )

      {
        bookings: confirmed_bookings.count,
        tickets: confirmed_bookings.joins(:booking_seats).count,
        collection: successful_payments.sum(:amount)
      }
    end


    # =========================================================
    # SUPER ADMIN
    # ALL MOVIE COLLECTIONS
    # =========================================================

  def movie_collections
  Movie.joins(shows: { bookings: :payment })
    .where(
      bookings: { status: "CONFIRMED" },
      payments: { status: "SUCCESS" }
    )
    .group("movies.id", "movies.title")
    .select(
      "movies.id",
      "movies.title",
      "COUNT(DISTINCT bookings.id) AS bookings_count",
      "COALESCE(SUM(payments.amount), 0) AS collection"
    )
    .order("collection DESC")
    .map do |movie_report|
      tickets_count = BookingSeat
        .joins(:booking)
        .where(
          bookings: {
            show_id: movie_report.shows.select(:id),
            status: "CONFIRMED"
          }
        )
        .count

      movie_report.define_singleton_method(:tickets_count) { tickets_count }

      movie_report
    end
end

    # =========================================================
    # ONE MOVIE
    # =========================================================

    def for_movie(movie)
      show_ids = movie.shows.select(:id)

      confirmed_bookings = Booking.where(
        show_id: show_ids,
        status: "CONFIRMED"
      )

      successful_payments = Payment.joins(:booking).where(
        bookings: {
          show_id: show_ids,
          status: "CONFIRMED"
        },
        status: "SUCCESS"
      )

      {
        bookings: confirmed_bookings.count,
        tickets: confirmed_bookings.joins(:booking_seats).count,
        collection: successful_payments.sum(:amount),
        theatres: theatre_breakdown_for_movie(movie)
      }
    end


    # =========================================================
    # PRIVATE METHODS
    # =========================================================

    private

    def auditorium_breakdown(theatre)
      theatre.auditoriums.map do |auditorium|
        report = for_auditorium(auditorium)

        {
          auditorium: auditorium,
          bookings: report[:bookings],
          tickets: report[:tickets],
          collection: report[:collection]
        }
      end
    end


def movie_breakdown_for_theatre(theatre)
  theatre.shows
    .joins(:movie)
    .joins(bookings: :payment)
    .where(
      bookings: { status: "CONFIRMED" },
      payments: { status: "SUCCESS" }
    )
    .group("movies.id", "movies.title")
    .select(
      "movies.id",
      "movies.title",
      "COUNT(DISTINCT bookings.id) AS bookings_count",
      "COALESCE(SUM(payments.amount), 0) AS collection"
    )
    .order("collection DESC")
    .map do |movie_report|
      tickets_count = BookingSeat
        .joins(:booking)
        .where(
          bookings: {
            show_id: theatre.shows.where(movie_id: movie_report.id).select(:id),
            status: "CONFIRMED"
          }
        )
        .count

      movie_report.define_singleton_method(:tickets_count) { tickets_count }

      movie_report
    end
end




def theatre_breakdown_for_movie(movie)
  movie.shows
       .joins(:theatre)
       .joins(bookings: :payment)
       .where(
         bookings: { status: "CONFIRMED" },
         payments: { status: "SUCCESS" }
       )
       .group("theatres.id", "theatres.name")
       .select(
         "theatres.id",
         "theatres.name",
         "COUNT(DISTINCT bookings.id) AS bookings_count",
         "COALESCE(SUM(payments.amount), 0) AS collection"
       )
       .order("collection DESC")
end



  end
end

