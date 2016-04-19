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
      puts "Do you want to scrape shows from the web (s) or open the local file (o)?"
      puts "you can also type \'t\' to create local temp file or \'q\' to quit"
      usr_input = gets.chomp

      case usr_input
      when 's'
        make_shows
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
