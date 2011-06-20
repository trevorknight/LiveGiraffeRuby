namespace :scrapers do
    desc "Scrape the evenko calendar"
    task :evenko => :environment do
        require 'rubygems'
        require 'mechanize'
        require 'htmlentities' #for html entity decoding
        agent = Mechanize.new
        scraper = "evenko.ca"
        page = agent.get('http://www.evenko.ca/en/show/events')

        form = page.form_with(:action => "show/events")
        form.filter_by_city_name = "Montreal"
        form.filter_by_category = "music"
        page = form.submit

        coder = HTMLEntities.new
        
        user = User.find_by_email('contact@livegiraffe.com')
        puts("userid is #{user.id}")

        while(1) do #ugly, fix

              #STEP 1: scrape listings page
              page.search(".listing-tr-thumb").each do |listing|
                if listing.search(".show").inner_html.to_s() =~ /<a href="(.*?)">(.*)<\/a>.*<br>(.*)/
                    ticket_url = $1.strip
                    artist_name = coder.decode($2)
                    venue_name = coder.decode($3)
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

                #STEP 2: scrape event page
                events_page = agent.get(ticket_url)
                if events_page.search(".ticket-price").inner_html.to_s() =~ /\$(\d+(\.\d\d)?)/
                    cost = $1
                else
                    puts "Couldn't match ticket cost :("
                end

                #STEP 2: sync DB
                
                #VENUES
                puts "About to check out #{venue_name}"
                venue_tokens = venue_name.strip.split #whitespace tokenize
                venue_permutations = []
                venue_results = []
                1.upto(venue_tokens.size) { |i| venue_permutations.push(venue_tokens.permutation(i).to_a) } #build array of token permutations
                venue_permutations.each do |p|
                    venue_results.push(Venue.where_name(p.join(" "))) #retrieve matches from DB
                end
                
                venue_matches = {}

                if(venue_results[1]) #if there are any results...
                    venue_results[1].each { |r| venue_matches[r.name] = r} #build hash of matches to eliminate duplicates
                end

                if venue_matches.size == 1 #exactly one venue match; assume that we've found the intended venue
                    venue = venue_matches[venue_matches.keys[0]];
                #TODO
                else #zero or more than 1 matches; either we don't know the venue at all, or it's ambiguous     
                    #for now: create new venue
                    #TODO: only create new if zero matches; if multiple, store into disambiguation table for manual editing
                    venue = Venue.new
                    venue.name = venue_name.strip
                    venue.address = "scraped" unless venue.id?
                    venue.save
                end

                

                artist = Artist.find_or_create_by_name(artist_name.strip)
                artist.user_id = user.id unless artist.id? 
                artist.save
                

                start_time = DateTime.parse(day.to_s + " " + month + " " + DateTime.now.year.to_s + " " + time); #TODO Fix year logic
                event = Event.joins([:artists, :venue]).where('artists.id = ? AND venues.id = ? AND events.start_time = ?', artist, venue, start_time)

                if event.blank? 
                    event = Event.new
                    event.artists = [artist]
                    event.venue = venue
                    event.start_time = start_time 
                    event.user_id = user.id
                    event.scraper = scraper
                    event.ticket_url = ticket_url
                    event.cost = cost
                    puts "Calling event.save on #{event.artists[0].name}, #{event.venue.name}, #{event.cost}, #{event.start_time}"
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
