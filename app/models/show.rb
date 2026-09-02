class Show < ApplicationRecord
  belongs_to :movie
  belongs_to :theatre
  belongs_to :auditorium

   has_many :show_seats, dependent: :destroy
  has_many :bookings, dependent: :destroy

  STATUSES = %w[ACTIVE INACTIVE].freeze
  validates :show_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :status,
            presence: true,
            inclusion: { in: STATUSES }
  validate :end_time_after_start_time
  validate :auditorium_belongs_to_theatre
  validate :no_timing_conflict
  validate :show_must_be_in_future

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end

  def auditorium_belongs_to_theatre
    return if auditorium.blank? || theatre.blank?

    if auditorium.theatre_id != theatre_id
      errors.add(:auditorium, "must belong to the selected theatre")
    end
  end

  def no_timing_conflict
    return if show_date.blank? ||
              start_time.blank? ||
              end_time.blank? ||
              auditorium_id.blank?

    conflicting_show = Show
      .where(auditorium_id: auditorium_id, show_date: show_date)
      .where.not(id: id)
      .where("start_time < ? AND end_time > ?", end_time, start_time)
      .exists?

    if conflicting_show
      errors.add(
        :base,
        "This auditorium already has a show during the selected time"
      )
    end
  end

  def show_must_be_in_future
    return if show_date.blank? ||
              start_time.blank?

    show_datetime = Time.zone.local(
      show_date.year,
      show_date.month,
      show_date.day,
      start_time.hour,
      start_time.min,
      start_time.sec
    )

    if show_datetime <= Time.current
      errors.add(:show_date, "and start time must be in the future")
    end
  end
end
