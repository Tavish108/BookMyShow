class ShowSeat < ApplicationRecord
  belongs_to :show
  belongs_to :seat

  STATUSES = %w[AVAILABLE HELD BOOKED].freeze

  validates :status,
            presence: true,
            inclusion: { in: STATUSES }

  validates :seat_id,
            uniqueness: {
              scope: :show_id,
              message: "is already assigned to this show"
            }

  validate :seat_belongs_to_show_auditorium

  def available?
    status == "AVAILABLE" ||
      (status == "HELD" && held_until.present? && held_until <= Time.current)
  end

  def held?
    status == "HELD" && held_until.present? && held_until > Time.current
  end

  def booked?
    status == "BOOKED"
  end

  private

  def seat_belongs_to_show_auditorium
    return if show.blank? || seat.blank?

    if seat.auditorium_id != show.auditorium_id
      errors.add(:seat, "must belong to the show's auditorium")
    end
  end
end