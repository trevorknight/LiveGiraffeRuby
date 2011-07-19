class Venue < ActiveRecord::Base
  has_many :events, :order => "start_time ASC", :dependent => :nullify
  belongs_to :user
  
  validates :name, :presence => true, 
                   :uniqueness => true
  validates :address, :presence => true
  
  default_scope order('venues.name')
  scope :where_name, lambda {|term| where("venues.name LIKE ?", "%#{term}%") }
  scope :recently_updated, lambda {where("venues.updated_at > ?", 5.days.ago) }
				   
  def owned_by?(owner)
    return false unless owner.is_a? User
    user == owner
  end
end
