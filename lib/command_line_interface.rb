require_relative "../lib/scraper.rb"
require_relative "../lib/the_list.rb"
require_relative "../lib/show.rb"
require 'nokogiri'
# require 'colorize'
require 'pry'


class CommandLineInteface
  BASE_URL = "http://hellashows.com/"

  def run
    make_shows

  end

  # Scrape the BASE_URL and create a Show object from each element in shows_array
  def make_shows
    shows_array = Scraper.scrape_index_page(BASE_URL)
    Show.create_from_collection(shows_array)
  end

end
