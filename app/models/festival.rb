class Festival < ActiveRecord::Base

  has_many :events
  
  scope :upcoming, lambda { where("events.start_time > ?", Time.now)}
  scope :on_now, lambda { where("events.start_time < ? AND events.end_time > ?", Time.now, Time.now) }
  scope :past, lambda { where("events.end_time < ?", Time.now)}

end
