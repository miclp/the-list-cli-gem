require 'open-uri'
require 'nokogiri'
require 'pry'


class Scraper

  def self.scrape_index_page(index_url)
    # Open the url with nokogiri
    index_page = Nokogiri::HTML(open(index_url))

    # array of shows to be returned
    shows = []
    dummy_array = []

    index_page.css("body div.container").each_with_index do |show, index|
      dummy_array << show
      # build this out to make an array of show hashes with basic attributes
      # don't create Show objects though.
      # shows << {:venue => , :bands => , }
      shows[index] = {}
      # Create an array of bands at the :bands key
      shows[index][:bands] = show.css(".bands").collect {|band| band.css("a").text}

      # Venue
      #  dummy_array[0].css("div.showHeader a")[0].text
      shows[index][:venue] = show.css("div.showHeader a")[0].text

      # Date
      shows[index][:date] = {:mmdd => show.css("div.dateBox div")[0].text, :day_of_week => show.css("div.dateBox div")[1].text}

      # Show url
      # Get the relative url and strip away the './' characters
      relative_url = show.css("div.showInfo a").attribute("href").value[/(?<=\.\/).*/]
      # concatenate the relative url with the base, or index_url to get a full url
      shows[index][:show_url] = index_url + relative_url

    end
    # Good place for a pry to look at shows.
    # binding.pry  # look at dummy_array[0] to see what the first show looks like
    shows
  end

  # Create a temp file (that can be loaded later)
  def self.create_local_temp_file(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    newfile = File.open("temp", "w")

    newfile.write(index_page)
    newfile.close
  end

  # doesn't work
  def self.open_local_file(path_to_file)
    noko_file = Nokogiri::HTML(open(path_to_file))
    # noko_file = File.open(path_to_file)
    binding.pry
    # syntax from nokogiri docs:
    # noko_file = File.open(path_to_file) { |f| Nokogiri::HTML(f) }
  end
end

#### NOTES ####

#scrape_index_page can probably be refactored to build a temp show hash and then
# << shovel it into the shows array at the end.
