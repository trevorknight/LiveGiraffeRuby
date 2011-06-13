class Event < ActiveRecord::Base
  
  belongs_to :venue
  has_and_belongs_to_many :artists

  
  attr_reader :artist_tokens
  attr_reader :venue_token
  
  validates :start_time, :venue_id, :presence => true
 
  default_scope order('events.start_time')
  scope :upcoming, lambda { where("events.start_time > ?", Time.now)}
  scope :past, lambda { where("events.start_time < ?", Time.now)}
 
  def artist_tokens=(ids)
    self.artist_ids = ids.split(",")
  end
  
  def venue_token=(id)
    self.venue_id = id
  end
  
  # def venue_name
    # venue.name if venue
  # end
  
  # def venue_name=(name)
    # self.venue = Venue.find_or_create_by_name(name) unless name.blank?
  # end
  
   
end
