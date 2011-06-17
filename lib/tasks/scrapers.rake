namespace :scrapers do
    desc "Scrape the evenko calendar"
    task :evenko => :environment do
        require 'rubygems'
        require 'mechanize'
        require 'htmlentities' #for html entity decoding
        agent = Mechanize.new
        page = agent.get('http://www.evenko.ca/en/show/events')

        form = page.form_with(:action => "show/events")
        form.filter_by_city_name = "Montreal"
        form.filter_by_category = "music"
        page = form.submit

        coder = HTMLEntities.new
        
        user = User.find_by_email('contact@livegiraffe.com')

        while(1) do #ugly, fix

              #STEP 1: scrape page
              page.search(".listing-tr-thumb").each do |listing|
                if listing.search(".show").inner_html.to_s() =~ /<a href=.*?>(.*)<\/a>.*<br>(.*)/
                    artist_name = coder.decode($1)
                    venue_name = coder.decode($2)
                else
                    puts "Couldn't match show :("
                end

                city_name = coder.decode(listing.search(".city").inner_html.strip)
                puts "Couldn't match city :(" unless city_name

                if listing.search(".date").inner_html.to_s() =~ /(\w+).*"day">(\d+)/
                    month = coder.decode($1)
                    day = coder.decode($2)
                else
                    puts "Couldn't match date :("
                end

                time = coder.decode(listing.search(".time").inner_html.strip)
                puts "Couldn't match time :(" unless time

                #STEP 2: sync DB
                venue = Venue.find_or_create_by_name(venue_name.strip) 
                venue.address = "scraped" unless venue.id?
                venue.save
                
                print "About to save artist: ", artist_name, ", venue: ", venue_name, "\n"

                artist = Artist.find_or_create_by_name(artist_name.strip)
                artist.user_id = user.id unless artist.id? 
                artist.save
                

                date = DateTime.parse(day.to_s + " " + month + " " + DateTime.now.year.to_s + " " + time);
                event = Event.joins([:artists, :venue]).where('artists.id = ? AND venues.id = ?', artist, venue)
                
                if event.blank? 
                    event = Event.new
                    event.artists = [artist]
                    event.venue = venue
                    event.start_time = date
                    event.user_id = user.id
                    event.save
                end
            end

            
            #STEP 3: navigate to next page
            nextPageLink = page.link_with(:text => '>')
            if nextPageLink == nil
                puts "No more next pages"
                break
            else
                page = nextPageLink.click
            end
        end

    end
end
