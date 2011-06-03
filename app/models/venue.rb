class Venue < ActiveRecord::Base
  has_many :events, :order => "start_time ASC", :dependent => :nullify
  
  validates :name, :presence => true, 
                   :length => { :minimum => 3 },
				   :uniqueness => true
				   
  
end
