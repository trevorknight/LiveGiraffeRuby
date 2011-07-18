class Festival < ActiveRecord::Base

  has_many :events
  
  scope :upcoming, lambda { where("festivals.start_time > ?", Time.now)}
  scope :on_now, lambda { where("festivals.start_time < ? AND events.end_time > ?", Time.now, Time.now) }
  scope :past, lambda { where("festivals.end_time < ?", Time.now)}

end
