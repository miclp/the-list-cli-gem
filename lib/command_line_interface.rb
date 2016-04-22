require_relative "../lib/scraper.rb"
require_relative "../lib/the_list.rb"
require_relative "../lib/show.rb"
require 'nokogiri'
require 'colorize'
require 'pry'


class CommandLineInteface
  BASE_URL = "http://hellashows.com/"

  def run
    while true
      puts ""
      puts "Here are your choices:"
      puts "\'s\' Scrape shows from the web."
      puts "\'a\' Add attributes to shows."
      puts "\'d\' Display all shows."
      puts "\'i\' Display one show."
      puts "\'o\' Open the local file."
      puts "\'t\' Create local temp file."
      puts "\'q\' to quit."
      puts "Development stuff: "
      puts "\'l\' Open the index.html page and pry."
      puts "\'p\' to pry into \#Show code."

      usr_input = gets.chomp

      case usr_input
      when 's'
        make_shows
      when 'a'
        add_attributes_to_shows
      when 'd'
        display_all_shows
      when 'i'
        display_show_interface
      when 'o'
        open_local_file
      when 't'
        create_local_temp_file
      when 'l'
        Scraper.open_index_page(BASE_URL)
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
    shows_array = Scraper.scrape_index_page(BASE_URL)
    Show.create_from_collection(shows_array)
  end

  def add_attributes_to_shows
    Show.all.each do |show|
      attributes = Scraper.scrape_show_page(show.show_url)
      show.add_show_attributes(attributes)
    end
  end

  def display_show_interface
    puts "There are #{Show.all.size} shows.  Enter the number of the show you'd like to display"
    usr_input = get_usr_input.to_i
    if usr_input <= Show.all.size
      display_show(usr_input)
    end
  end

  # Take a show num in "base 1 indexing" and return the show from Show.all
  def display_show(show_num)
    disp_horiz_line
    show = Show.all[show_num - 1]
    show.instance_variables.each do |v|
      value = show.instance_variable_get(v)
      puts " #{v}:".sub(/@/, '').colorize(:light_blue) + " #{value}"
    end
    disp_horiz_line
  end

  def display_all_shows
    disp_horiz_line
    Show.all.each do |show|
      # puts"#{student.name.upcase}".colorize(:blue)
      show.instance_variables.each do |v|
        value = show.instance_variable_get(v)
        puts " #{v}:".sub(/@/, '').colorize(:light_blue) + " #{value}"
      end
      disp_horiz_line
    end
  end

  def disp_horiz_line(color = :green)
    puts "--------------------------------------------------".colorize(color)
  end

  def create_local_temp_file
    Scraper.create_local_temp_file(BASE_URL)
  end

  def open_local_file
    local_path = File.join(File.dirname(__FILE__), "../temp")
    Scraper.open_local_file(local_path)
  end

end
