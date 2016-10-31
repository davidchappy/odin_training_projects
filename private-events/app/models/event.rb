class Event < ApplicationRecord
  has_many :attendences, :foreign_key => :attended_event_id
  belongs_to :creator, :class_name => "User" 
  has_many :attendees, :through => :attendences
  scope :upcoming, -> { where("date >= ?", Time.zone.now) }
  scope :past, -> { where("date < ?", Time.zone.now) }

end
