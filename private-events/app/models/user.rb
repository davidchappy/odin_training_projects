class User < ApplicationRecord
  has_many :attendences, :foreign_key => :attendee_id
  has_many :attended_events, :through => :attendences
  has_many :created_events, :foreign_key => :creator_id, :class_name => "Event"

  def upcoming_events
    self.attended_events.where("date >= ?", Time.zone.now)
  end

  def past_events
    self.attended_events.where("date < ?", Time.zone.now)
  end

end
