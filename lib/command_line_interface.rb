require_relative "../lib/scraper.rb"
require_relative "../lib/the_list.rb"
require_relative "../lib/show.rb"
require_relative "../lib/show_importer.rb"
require 'nokogiri'
require 'colorize'
require 'pry'


class CommandLineInteface

  attr_accessor :importer

  BASE_URL = "http://hellashows.com/"

  def run

    puts "Welcome to the command line interface (CLI) of Steve Koepke's \'list\'"
    puts "via www.hellashows.com!"
    puts "hellashows.com is a great website that gets information on SF Bay Area"
    puts "concerts from Steve Koepke's \'the list\', a weekly newsletter."
    puts "See http://www.calweb.com/~skoepke/ for the original source.\n\n"
    puts "To use this CLI, type the letter for the command you want to run and hit \'enter\'\n"

    # Start by scraping shows from the BASE_URL.
    puts "Scraping shows from #{BASE_URL}..."
    make_shows
    puts "Just imported shows with timestamp: #{self.importer.timestamp}."
    while true
      disp_horiz_line
      puts "Here are your choices:"

      puts "\'a\' Add attributes to shows. (adds map link and additional info.)"
      puts "\'d\' Display all shows."
      puts "\'b\' List all bands/artists."
      puts "\'i\' Display one show."
      puts "\'m\' Open venue location in Google maps."
      puts "\'c\' Display all shows on a given date (mm/dd format)"
      puts "\'w\' Display all shows on a given weekday"
      # puts "\'o\' Open the local file."
      # puts "\'t\' Create local temp file."
      puts "\'s\' Re-Scrape shows from the web. (Shows were last scraped at #{self.importer.timestamp}."
      puts "\'q\' to quit."
      puts "Development stuff: "
      puts "\'l\' Open the index.html page and pry."
      puts "\'k\' Open a show url and pry."
      puts "\'p\' to pry into \#Show code."

      usr_input = get_usr_input

      case usr_input
      when 's'
        make_shows
      when 'a'
        Show.add_attributes_to_shows
      when 'd'
        Show.display_all_shows
      when 'i'
        display_show_interface
      when 'm'
        open_google_map
      when 'b'
        Show.display_all_bands
      # when 'o'
      #   open_local_file
      # when 't'
      #   create_local_temp_file
      when 'c'
        # prompt user for mm/dd and display shows on that date
        display_by_date
      when 'w'
        # prompt user for a weekday and display shows that fall on that day of week
        display_by_weekday
      when 'l'
        pry_index_page
      when 'k'
        pry_show_page
      when 'p'
        Show.pry_into_code
      when 'q'
        puts 'bye!'
        break
      else
      end
    end

  end

  def get_usr_input
    gets.chomp
  end

  # Scrape the BASE_URL and create a Show object from each element in shows_array
  def make_shows
    @importer = ShowImporter.new(BASE_URL)
    @importer.import
  end

  ### shouldn't go in show.rb
  def display_show_interface
    puts "There are #{Show.all.size} shows.  Enter the number of the show you'd like to display"
    usr_input = get_usr_input.to_i
    if usr_input <= Show.all.size
      disp_horiz_line
      Show.display_show(usr_input)
      disp_horiz_line
    end
  end

  def disp_horiz_line(color = :green)
    puts "--------------------------------------------------".colorize(color)
  end

  def open_google_map
    puts "Which show number?"  # Need to check for valid input?
    usr_input = get_usr_input.to_i
    return nil if usr_input > Show.all.size # hack valid input check
    show = Show.all[usr_input - 1]
    puts "You are about to open the map url for:"
    puts "#{show.venue}"
    puts "on your default web browser. Press enter to continue or type \'n\' to skip."
    usr_input = get_usr_input
    show.open_in_google_maps unless usr_input == 'n'
    nil
  end


  def display_by_date
  end

  # use Show.weekday
  def display_by_weekday
    days_of_week = {1 => "MONDAY", 2 => "TUESDAY", 3 => "WEDNESDAY", 4 => "THURSDAY", 5 => "FRIDAY", 6 => "SATURDAY", 7 => "SUNDAY"}
    puts "Which day would you like to see shows from? (1-7)"
    days_of_week.each do |index, day|
      puts "#{index}. #{day}"
    end
    input = get_usr_input.to_i
    Show.display_some_shows(Show.weekday(days_of_week[input]))
  end

  # Coding/Debugging stuff

  def pry_index_page
    Scraper.pry_index_page(BASE_URL)
  end

  def pry_show_page
    puts "You can type the number of a show you want to pry into, or paste a url"
    puts "Type \'p\' to paste a url, otherwise type a show number"
    usr_input = get_usr_input
    if usr_input == 'p'
      puts "Paste or type the url of the page you want to pry into."
      url = get_usr_input
    else
      usr_input = usr_input.to_i
      url = Show.all[usr_input - 1].show_url
    end
    Scraper.pry_show_page(url)
  end

  def create_local_temp_file
    Scraper.create_local_temp_file(BASE_URL)
  end

  def open_local_file
    local_path = File.join(File.dirname(__FILE__), "../temp")
    Scraper.open_local_file(local_path)
  end

end
