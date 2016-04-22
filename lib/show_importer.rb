require_relative "../lib/scraper.rb"
require_relative "../lib/the_list.rb"
require_relative "../lib/show.rb"
require_relative "../lib/command_line_interface.rb"
require 'nokogiri'
require 'colorize'
require 'pry'

class ShowImporter

  attr_accessor :base_url

  def initialize(url)
    @base_url = url
  end

  def import
    shows_array = Scraper.scrape_index_page(self.base_url)
    Show.create_from_collection(shows_array)
  end
end
