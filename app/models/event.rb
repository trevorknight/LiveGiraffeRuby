class Event < ActiveRecord::Base
  
  belongs_to :venue
  belongs_to :user
  belongs_to :festival
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :profiles
  
  attr_reader :artist_tokens
  attr_reader :venue_token
  
  validates :start_time, :venue_id, :artists, :presence => true
 
  default_scope order('events.start_time')
  scope :upcoming, lambda { where("events.start_time > ?", Time.now)}
  scope :past, lambda { where("events.start_time < ?", Time.now)}
 
  def show_cost
    if self.cost
      if self.cost.nonzero?
        "#{I18n.t('views.events.cost')}: $#{self.cost}"
      else
        t('general.free')
      end
    end
  end
 
  def artist_tokens=(ids)
    self.artist_ids = ids.split(",")
  end
  
  def venue_token=(id)
    self.venue_id = id
  end
  
  def owned_by?(owner)
    return false unless owner.is_a? User
    user == owner
  end
  
   
end
