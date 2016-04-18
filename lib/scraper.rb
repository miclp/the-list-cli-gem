require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    # index_page = Nokogiri::HTML(open("http://127.0.0.1:4000/"))
    index_page = Nokogiri::HTML(open(index_url))
    shows = []
    all_shows = index_page.css("body")
    # binding.pry
    # all_shows.css("div.container")[0] gives the first show.
    all_shows.css("div.container").each do |show|
      shows << show
      # build this out to make an array of show hashes with basic attributes
      # don't create Show objects though.
      # shows << {:venue => , :bands => , }
    end
    binding.pry
    shows
  end

end


#### NOTES ####

# shows[9].css("div.dateBox div")[0].text
# => "4/20"
#
# shows[9].css("div.dateBox div")[1].text
# => "WEDNESDAY"

# PROBLEM HERE:  can't find the text values
# shows[0].css("div.showHeader .venueLink")
# => [#<Nokogiri::XML::Element:0x3fd8e157e9b0 name="a" attributes=[#<Nokogiri::XML::Attr:0x3fd8e203f0fc name="class" value="venueLink">, #<Nokogiri::XML::Attr:0x3fd8e203f0e8 name="href" value="?venue=">]>]
