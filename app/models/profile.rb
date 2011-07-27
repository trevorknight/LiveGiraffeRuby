class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :saved_events
  has_many :events, :through => :saved_events
  
  def owned_by(owner)
    return false unless owner.is_a? User
    user == owner
  end
end
