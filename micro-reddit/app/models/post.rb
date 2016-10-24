class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title,   presence: true, 
                      length: { minimum: 4 }
  validates :body,    presence: true,
                      length: { minimum: 30 }
  validates :user_id, presence: true
end
