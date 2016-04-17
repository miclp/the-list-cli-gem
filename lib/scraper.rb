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
    end
    binding.pry
    shows
  end

end
