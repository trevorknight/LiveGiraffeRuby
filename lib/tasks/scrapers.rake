namespace :scrapers do
    desc "Scrape the evenko calendar"
    task :evenko => :environment do
        require 'rubygems'
        require 'mechanize'
        agent = Mechanize.new
        page = agent.get('http://www.evenko.ca/en/show/events')

        form = page.form_with(:action => "show/events")
        form.filter_by_city_name = "Montreal"
        form.filter_by_category = "music"
        page = form.submit

        while(1) do #ugly, fix

              #STEP 1: scrape page
              page.search(".listing-tr-thumb").each do |listing|
                if listing.search(".show").inner_html.to_s() =~ /<a href=.*?>(.*)<\/a>.*<br>(.*)/
                    artist_name = $1
                    venue_name = $2
                else
                    puts "Couldn't match show :("
                end

                city_name = listing.search(".city").inner_html.strip
                puts "Couldn't match city :(" unless city_name

                if listing.search(".date").inner_html.to_s() =~ /(\w+).*"day">(\d+)/
                    month = $1
                    day = $2
                else
                    puts "Couldn't match date :("
                end

                time = listing.search(".time").inner_html.strip
                puts "Couldn't match time :(" unless time

                #STEP 2: sync DB
                venue = Venue.find_or_create_by_name(venue_name.strip)
                venue.address = "scraped" unless venue.id?
                venue.save
                
                print "About to save artist: ", artist_name, ", venue: ", venue_name, "\n"

                artist = Artist.find_or_create_by_name(artist_name.strip)

                date = DateTime.parse(day.to_s + " " + month + " " + DateTime.now.year.to_s + " " + time);
                event = Event.joins([:artists, :venue]).where('artists.id = ? AND venues.id = ?', artist, venue)

                if event.blank? 
                    event = Event.new
                    event.artists = [artist]
                    event.venue = venue
                    event.start_time = date
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
