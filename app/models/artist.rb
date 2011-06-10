class Artist < ActiveRecord::Base
  has_and_belongs_to_many :events
  
  validates :name, :presence => true,
                   :length => { :minimum => 2 },
				   :uniqueness => true
  
  scope :where_name, lambda {|term| where("artists.name LIKE ?", "%#{term}%") }
  
    
end
