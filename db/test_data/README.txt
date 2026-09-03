BookMyShow test dataset generated to match the supplied schema.rb and model validations.

Counts:
users 120
roles 3
user_roles 116
languages 7
genres 10
theatres 15
auditoria 30
seats 2400
movies 20
movie_genres 40
shows 480
show_seats 38400
bookings 100
booking_seats 255
payments 80
tickets 80

Important:
- User password_digest is blank. The Rails importer should assign password "Test@12345" through User#password so has_secure_password creates a valid digest.
- Shows begin on 2026-09-04, so they pass the current future-show validation.
- Shows use only daytime/evening slots and never cross midnight.
- Shows are non-overlapping within an auditorium.
- Every show's auditorium belongs to its theatre.
- Every show_seat's seat belongs to that show's auditorium.
- Booking show_seat IDs are unique across the generated bookings.
- pending_registrations and verification_otps are intentionally omitted; these should be created by the registration/OTP application flow.
