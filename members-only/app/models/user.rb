class User < ApplicationRecord
  attr_accessor :remember_token
  has_many :posts
  before_create :remember
  has_secure_password

  def remember
    token = SecureRandom.urlsafe_base64
    self.remember_token = token
    self.remember_digest = Digest::SHA1.hexdigest(token.to_s)
  end

end
