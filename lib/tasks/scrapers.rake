desc "Scrape the evenko calendar"
task :scrape_evenko => :environment do
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
                print "Name is ", $1, ", venue is ", $2, "\n"
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
        end

        nextPageLink = page.link_with(:text => '>')
        if nextPageLink == nil
            puts "No more next pages"
            break
        else
            page = nextPageLink.click
        end
    end

end
