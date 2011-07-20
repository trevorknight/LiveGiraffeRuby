require 'nokogiri'
require 'open-uri'
require 'uri'
echoKey = 'TTXOSQ9K9L1WDCRFA'

class Artist < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :events
    
  validates :name, :presence => true,
                   :uniqueness => true
  
  default_scope order('artists.name')
  scope :where_name, lambda {|term| where("artists.name LIKE ?", "%#{term}%") }
  
  def before_create
      #retrieve canonical artist name from echonest
      echonest = Nokogiri::HTML(open("http://developer.echonest.com/api/v4/artist/search?api_key=#{echoKey}&name=#{URI.escape(name)}&format=xml"))
      name = echonest.css('name').first.inner_html
  end

  def owned_by?(owner)
    return false unless owner.is_a? User
    user == owner
  end
end
