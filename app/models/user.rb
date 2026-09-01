class User < ApplicationRecord

  has_secure_password

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :bookings, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  normalizes :email, with: ->(email) { email.strip.downcase } #" tavish@gmail.com " -> "tavish@gmail.com"

  
  has_many :created_movies,
         class_name: "Movie",
         foreign_key: :created_by_id,
         dependent: :restrict_with_error

  has_many :created_theatres,
         class_name: "Theatre",
         foreign_key: :created_by_id



  def has_role?(role_name)
    roles.exists?(name: role_name)
  end
end



# user.roles
# user.user_roles
# user.has_role?("USER")