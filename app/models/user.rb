require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessor :profile_name
  
  validates :email, :uniqueness => true, 
                    :length => { :within => 5..50 },
                    :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
  validates :password, :confirmation => true,
                       :length => { :within => 4..20 },
                       :presence => true,
                       :if => :password_required?
  
  has_one :profile
  has_many :events
  has_many :venues
  has_many :artists
  
  before_save :encrypt_new_password
  before_save :downcase_email
  after_save :save_profile_name
  before_validation :downcase_email
  
  def downcase_email
    self.email.downcase!
  end
  
  def save_profile_name
    self.profile = Profile.find_or_create_by_user_id(self.id)
    self.profile.name = profile_name
    self.profile.save
  end
  
  def self.authenticate(email, password)
    email.downcase!
    user = User.find_by_email(email)
    return user if user && user.authenticated?(password)
  end
  
  def authenticated?(password)
    self.hashed_password == encrypt(password)
  end
  
  protected
    def encrypt_new_password
      return if password.blank?
      self.hashed_password = encrypt(password)
    end
    
    def password_required?
      hashed_password.blank? || password.present?
    end
    
    def encrypt(string)
      Digest::SHA1.hexdigest(string)
    end
end
