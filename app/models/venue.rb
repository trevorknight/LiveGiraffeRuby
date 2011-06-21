class Venue < ActiveRecord::Base
  has_many :events, :order => "start_time ASC", :dependent => :nullify
  belongs_to :user
  
  validates :name, :presence => true, 
                   :length => { :minimum => 3 },
                   :uniqueness => true
  validates :address, :presence => true
  
  scope :where_name, lambda {|term| where("venues.name LIKE ?", "%#{term}%") }
				   
  def owned_by?(owner)
    return false unless owner.is_a? User
    user == owner
  end
end
