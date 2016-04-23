# Show objects (concert objects)
require 'pry'

class Show

  attr_accessor :bands, :venue, :date, :show_url, :original_text, :additional_info, :map#, :cost, :age_restrictions

  # Store all show objects in @@all
  @@all = []

  def initialize(show_hash)
    show_hash.each do |key, value|
      self.send "#{key}=" , value
    end
    @@all << self
  end

### BEGIN Class Methods ####

  def self.all
    @@all
  end

  def self.create_from_collection(shows)
    shows.each do |show_hash|
      Show.new(show_hash)
    end
  end

  # Scrape each individual show page from @@all and add attributes to each show.
  def self.add_attributes_to_shows
    self.all.each do |show|
      attributes = Scraper.scrape_show_page(show.show_url)
      show.add_show_attributes(attributes)
    end
  end

  # Take a show num in "base 1 indexing" and return the show from Show.all
  def self.display_show(show_num)
    show = self.all[show_num - 1]
    show.instance_variables.each do |v|
      value = show.instance_variable_get(v)
      puts " #{v}:".sub(/@/, '').colorize(:light_blue) + " #{value}"
    end
  end

  def self.display_all_shows
    # disp_horiz_line
    puts "------------------------------------------------"
    self.all.each do |show|
      show.instance_variables.each do |v|
        value = show.instance_variable_get(v)
        puts " #{v}:".sub(/@/, '').colorize(:light_blue) + " #{value}"
      end
      puts "------------------------------------------------"
    end
  end

  # For debugging only
  def self.pry_into_code
    binding.pry
  end

### END Class methods ###

### BEGIN Instance Methods ###


  def add_show_attributes(attributes_hash)
    attributes_hash.each do |key, value|
      self.send "#{key}=" , value
    end

    # Add the google maps query url for the venue location
    maps_url = "http://maps.google.com/?q=#{self.venue}"
    self.map = maps_url

    self
  end

  def open_in_google_maps
    if self.map
      venue_map = self.map
    else
      venue_map = "http://maps.google.com/?q=#{self.venue}"
      self.map = venue_map
    end
    system %{open "#{venue_map}"}
  end

### END Instance Methods ###

end
