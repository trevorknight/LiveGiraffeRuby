#!/usr/bin/ruby
require 'rubygems'
require 'mechanize'

agent = Mechanize.new
page = agent.get('http://www.evenko.ca/en/show/events')

form = page.form_with(:action => "show/events")
form.filter_by_city_name = "Montreal"
form.filter_by_category = "music"
page = form.submit

while(1) #ugly, fix
      page.search(".listing-tr-thumb").each do |listing|
        if listing.search(".show").inner_html.to_s() =~ /<a href=.*?>(.*)<\/a>.*<br>(.*)/
            artist_name = $1
			venue_name = $2
        else 
            puts "Couldn't match show :("
        end

        print "City is ", listing.search(".city").inner_html.strip, "\n"

        if listing.search(".date").inner_html.to_s() =~ /(\w+).*"day">(\d+)/
            print "Date is ", $1, " ", $2, "\n";
        else
            puts "Couldn't match date :("
        end
        
        print "Time is ", listing.search(".time").inner_html.strip, "\n"
		
		venue = Venue.find_or_create_by_name(venue_name)
	    venue.address = "scraped" unless venue.id?
		venue.save
		
        artist = Artist.find_or_create_by_name(artist_name)
		
		
    end
    
    nextPageLink = page.link_with(:text => '>')
    if nextPageLink == nil
        puts "No more next pages"
        break   
    else 
        page = nextPageLink.click
    end
end

puts ENV['RUBYOPT']
puts ENV['RUBYPATH']
puts ENV['RUBYLIB']
puts ENV['PATH']

#page.search(".events").each do |event|
#	if event.to_s() =~ /.*>(.*)<\/a><br>(.*?)<br>(.*)<\/p>/
#		print "Matched artist ",$1, ", location ",$2, ", time ", $3,"\n"
#	else
#		puts "Couldn't match!"
#		puts event
#	end
#end

