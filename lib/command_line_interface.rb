require_relative "../lib/scraper.rb"
require_relative "../lib/the_list.rb"
require_relative "../lib/show.rb"
require 'nokogiri'
# require 'colorize'
require 'pry'


class CommandLineInteface
  BASE_URL = "http://hellashows.com/"

  def run
    while true
      puts ""
      puts "Here are your choices:"
      puts "\'s\' Scrape shows from the web."
      puts "\'a\' Add attributes to shows."
      puts "\'o\' Open the local file."
      puts "\'t\' Create local temp file."
      puts "\'q\' to quit."
      usr_input = gets.chomp

      case usr_input
      when 's'
        make_shows
      when 'a'
        add_attributes_to_shows
      when 'o'
        open_local_file
      when 't'
        create_local_temp_file
      when 'q'
        puts 'bye!'
        break
      else
      end
    end

  end

  # Scrape the BASE_URL and create a Show object from each element in shows_array
  def make_shows
    shows_array = Scraper.scrape_index_page(BASE_URL)
    Show.create_from_collection(shows_array)
  end

  def add_attributes_to_shows
    Show.all.each do |show|
      attributes = Scraper.scrape_show_page(show.show_url)
      show.add_show_attributes(attributes)
    end
    binding.pry
  end

  def create_local_temp_file
    Scraper.create_local_temp_file(BASE_URL)
  end

  def open_local_file
    local_path = File.join(File.dirname(__FILE__), "../temp")
    Scraper.open_local_file(local_path)
  end

  # def create_temp_file
  #   hellashows_page = open("copy_of_hellashows.html")
  #   newfile = File.open("temp.html", "w")
  #   newfile.write(hellashows_page)
  #   newfile.close
  # end

end
