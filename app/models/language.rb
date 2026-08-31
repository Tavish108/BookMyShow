class Language < ApplicationRecord

  has_many :movies, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  
end
