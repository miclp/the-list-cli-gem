require 'open-uri'
require 'nokogiri'
require 'pry'
# for development only - probably want to remove for 'release' version
require 'memcached'


class Scraper

  ### NOTES ###
  #scrape_index_page can probably be refactored to build a temp show hash and then
  # << shovel it into the shows array at the end.
  ### End Notes ###

  # Open the www.hellashows.com index page and scrape each show for attributes.
  # Return an array of hashes, each hash containing the scraped attributes for a show.
  # The hashes can be passed to the #Show class, either individually or as an
  # array in #Show.create_from_collection.

  def self.scrape_index_page(index_url)
    # Open the url with nokogiri
    index_page = Nokogiri::HTML(open(index_url))

    # array of shows to be returned
    shows = []

    index_page.css("body div.container").each_with_index do |show, index|
      # make an array of show hashes with basic attributes

      # shows << {:venue => , :bands => , }
      shows[index] = {}
      # Create an array of bands at the :bands key
      shows[index][:bands] = show.css(".bands a").collect {|band| band.text.strip}
      ### note - the .strip takes off space [presumably] left in by hellashows.com

      # Venue
      shows[index][:venue] = show.css("div.showHeader a")[0].text

      # Date
      shows[index][:date] = {:mmdd => show.css("div.dateBox div")[0].text, :day_of_week => show.css("div.dateBox div")[1].text}

      # Show url
      # Get the relative url and strip away the './' characters
      relative_url = show.css("div.showInfo a").attribute("href").value[/(?<=\.\/).*/]
      # concatenate the relative url with the base, or index_url to get a full url
      shows[index][:show_url] = index_url + relative_url
    end
    shows
  end

  # #scrape_show_page takes the url of a show page and returns a hash with
  # additional information about the show.
  def self.scrape_show_page(show_url)
    show_page = Nokogiri::HTML(open(show_url))
    show_attributes = {}

    # Get original string
    show_attributes[:original_text] = show_page.css("div #originalString #stringText").text

    # Get additional attributes
    show_attributes[:additional_info] = show_page.css("div.showHeader font.attributes").text

    # Maps attributes
    # I'm not sure if this is the correct one?:
    # show_attributes[:map] = show_page.css("div iframe").attribute("src").value

    show_attributes
  end

  # NOTES for self.scrape_show_page
  # Original text (from Steve K's list)
  # show_page.css("div #originalString #stringText").text



end
