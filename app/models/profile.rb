class Profile < ActiveRecord::Base
  belongs_to :user
  
  def owned_by(owner)
    return false unless owner.is_a? User
    user == owner
  end
end
