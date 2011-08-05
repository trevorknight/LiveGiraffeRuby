class Artist < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :events
  before_create :canonicalise_name
    
  validates :name, :presence => true,
                   :uniqueness => true
  
  default_scope order('artists.name')
  scope :where_name, lambda {|term| where("artists.name LIKE ?", "%#{term}%") }
  
  def canonicalise_name
      require 'open-uri'
      require 'nokogiri'
      require 'htmlentities'
      coder = HTMLEntities.new
      echoKey = 'TTXOSQ9K9L1WDCRFA'
      #retrieve canonical artist name from echonest
      echonest = Nokogiri::HTML(open("http://developer.echonest.com/api/v4/artist/search?api_key=#{echoKey}&name=#{URI.escape(self.name)}&format=xml"))
      bestMatch = echonest.css('name').first
      if(bestMatch) 
          self.name = coder.decode(bestMatch.inner_html)
      end
  end

  def owned_by?(owner)
    return false unless owner.is_a? User
    user == owner
  end
end

