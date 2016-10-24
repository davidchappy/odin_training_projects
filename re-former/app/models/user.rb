class User < ApplicationRecord
  validates :username,    presence: true,
                          length: { minimum: 4 },
                          uniqueness: true

  before_save { email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, 
                    length: { maximum: 255 }, 
                    format: { with: VALID_EMAIL_REGEX }   

  has_secure_password
  validates :password, length: { minimum: 6 }, presence: true 
end
