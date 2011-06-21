class Artist < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :events
    
  validates :name, :presence => true,
                   :uniqueness => true
  
  scope :where_name, lambda {|term| where("artists.name LIKE ?", "%#{term}%") }
  
  def owned_by?(owner)
    return false unless owner.is_a? User
    user == owner
  end
end
