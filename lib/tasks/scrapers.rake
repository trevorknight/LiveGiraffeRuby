namespace :scrapers do 
    desc "Scrape the evenko calendar"
    task :evenko => :environment do
        require 'rubygems'
        require 'mechanize'
        require 'htmlentities' #for html entity decoding
        puts("*************")
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
                begin
                    show_matches = applyRegex(listing.search(".show").inner_html.to_s(), '<a href="(.*?)">(.*)</a>.*<br>(.*)')
                    date_matches = applyRegex(listing.search(".date").inner_html.to_s(),'(\w+).*"day">(\d+)')
                rescue RegexpError => e
                    puts("Couldn't match on listings page: #{e.message}")
                    next
                end

                ticket_url = show_matches[1].strip
                artist_name = coder.decode(show_matches[2])
                venue_name = coder.decode(show_matches[3])
                
                city_name = coder.decode(listing.search(".city").inner_html.strip)
                puts "Couldn't match city :(" unless city_name

                time = coder.decode(listing.search(".time").inner_html.strip)
                puts "Couldn't match time :(" unless time

                #STEP 2: scrape event page for ticket cost and ticket url
                events_page = agent.get(ticket_url)
                begin
                    ticket_matches = applyRegex(events_page.search(".ticket-price").inner_html.to_s(), '\$(\d+(\.\d\d)?)')
                    venue_matches = applyRegex(events_page.search(".venue").inner_html.to_s(), '<a href="(.*)">')
                    venue_url = applyRegex(events_page.search(".venue").inner_html.to_s(), '<a href="(.*)">')
                rescue RegexpError => e
                    puts("Couldn't match on events page: #{e.message}")
                    next
                end
                
                cost = ticket_matches[1]
                venue_url = venue_matches[1]
                    
                #STEP 3: scrape venue page for venue address, website and phone number
                venue_page = agent.get(venue_url)
                begin
                    venuedetail_matches = applyRegex(venue_page.search(".venue_listing p").inner_html.to_s().strip, '(.*),.*\((\d+)\)\s*(\d+)-(\d+)')
                    venuewebsite_matches = applyRegex(venue_page.search(".venue_listing p a").to_s().strip, '.*?href="(.*?)\/?"')
                rescue RegexpError => e
                    puts("Couldn't match on venue page: #{e.message}")
                    next
                end
                        
                venue_address = venuedetail_matches[1]
                venue_phone = venuedetail_matches[2].to_s() + 
                              venuedetail_matches[3].to_s() + 
                              venuedetail_matches[4].to_s()
                venue_website = venuewebsite_matches[1]
                
                    #VENUES
    #                puts "About to check out #{venue_name}"
    #                venue_tokens = venue_name.strip.split #whitespace tokenize
    #                venue_permutations = []
    #                venue_results = []
    #                1.upto(venue_tokens.size) { |i| venue_permutations.push(venue_tokens.permutation(i).to_a) } #build array of token permutations
    #                venue_permutations.each do |p|
    #                    venue_results.push(Venue.where_name(p.join(" "))) #retrieve matches from DB
    #                end
    #                
    #                venue_matches = {}
    #
    #                if(venue_results[1]) #if there are any results...
    #                    venue_results[1].each { |r| venue_matches[r.name] = r} #build hash of matches to eliminate duplicates
    #                end
    #
    #                if venue_matches.size == 1 #exactly one venue match; assume that we've found the intended venue
    #                    venue = venue_matches[venue_matches.keys[0]];
    #                    puts "woo! #{venue.class}"
                    #TODO
    #                else #zero or more than 1 matches; either we don't know the venue at all, or it's ambiguous     
                        #for now: create new venue
                        #TODO: only create new if zero matches; if multiple, store into disambiguation table for manual editing
                

                #STEP 4: sync with DB
                venue = Venue.find_or_create_by_name(venue_name.strip)
                unless venue.id
                    venue = Venue.new
                    venue.name = venue_name.strip
                    venue.address = venue_address
                    venue.phone = venue_phone
                    venue.website = venue_website
                    venue.user_id = user.id
                    #puts "calling venue.save for venue #{venue.name}"
                    venue.save
                end
                #puts "venue is #{venue.inspect}"
                #puts "venue id is #{venue.id}"
                #puts "user id is #{user.id}"

                artist = Artist.find_or_create_by_name(artist_name.strip)
                artist.user_id = user.id unless artist.id? 
                artist.save

                #puts "artist is #{artist.inspect}"
                #puts "artist id is #{artist.id}"

                start_time = DateTime.parse(date_matches[2].to_s + " " + date_matches[1] + " " + DateTime.now.year.to_s + " " + time); #TODO Fix year logic
                start_time_str = start_time.to_formatted_s(:db).gsub('%', '\%').gsub('_', '\_') + '%'
                event = Event.joins([:artists]).where('artists.id = ? AND events.venue_id = ? AND events.start_time like ?', artist.id, venue.id, start_time_str)

                #puts "Retrieved event with params artistid: #{artist.id}, venueid: #{venue.id}, start time: #{start_time_str}"
                #puts "Inspecting event: #{event.inspect}"

                if event.blank? 
                    event = Event.new
                    event.artists = [artist]
                    event.venue_id = venue.id
                    event.start_time = start_time 
                    event.user_id = user.id
                    event.scraper = scraper
                    event.ticket_url = ticket_url
                    event.cost = cost
                    #puts "Calling event.save on #{event.artists[0].name}, #{event.venue.name}, #{event.venue.address}, #{event.venue.phone}, #{event.venue.website}, #{event.cost}, #{event.start_time}"
                    event.save
                    puts("Event errors: #{event.errors}") unless event.errors.empty?
                end
                
            end

            #STEP 5: navigate to next page
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

def applyRegex (theString, theRegex)
    matches = theString.match(theRegex)
    unless matches
        raise RegexpError, "Couldn't match regex: #{theRegex} to string: #{theString.strip}"
    end
    return matches
end
