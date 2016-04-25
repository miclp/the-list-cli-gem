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
      Show.new(show_hash)  # could this be self.new(show_hash)?
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
    nil
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
    nil  # make sure this doesn't change behavior.  If so, remove it (will return @@all by default)
  end

  def self.display_some_shows(array)
    array.each do |show|
      show.display
      horiz_line
    end
    nil
  end

  ## note: combine display_by_artist and display_artist_shows by checking if the
  #  input is a string or integer and acting accordingly.

  # Take a number (corresponding to self.all_bands) and display all shows by that
  # artist.
  def self.display_by_artist(artist_number)
    artist = self.all_bands[artist_number - 1]
    artist_shows = self.select_shows_by_artist(artist)
    self.display_some_shows(artist_shows)
  end

  # Alternately, take an artist name and dispaly all shows by that artist.
  def self.display_artist_shows(artist)
    artist_shows = self.select_shows_by_artist(artist)
    self.display_some_shows(artist_shows)
  end

  # Select all shows with a given artist_name string
  def self.select_shows_by_artist(artist_name)
    self.all.select {|show| show.bands.include?(artist_name)}
  end

  # Return a list of all show dates
  def self.dates

  end

  # Return a list of all show artists
  def self.all_bands
    all_bands = []
    self.all.each do |show|
      show.bands.each do |band|
        all_bands << band if !all_bands.include?(band)
      end
    end
    all_bands.sort
  end

  # Display all bands as a numbered list
  def self.display_all_bands
    self.horiz_line
    puts "List of all bands in alphabetical order:"
    self.horiz_line
    self.all_bands.each_with_index do |band, index|
      puts "#{index + 1}. #{band}"
    end
    nil
  end

  # Return a list of all venues
  def self.list_venues
    all_venues = []
    self.all.each do |show|
      # Add the show's venue to venues if it isn't already in the list
      all_venues << show.venue if !all_venues.include?(show.venue)
    end
    all_venues.sort
  end

  # Return a list of shows that all fall on a specific weekday
  def self.weekday(day = "FRIDAY")
    self.all.select {|show| show.date[:day_of_week] == day}
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

  # Display all attributes of self (display one show)
  def display
    self.instance_variables.each do |v|
      value = self.instance_variable_get(v)
      puts " #{v}:".sub(/@/, '').colorize(:light_blue) + " #{value}"
    end
  end

  ### Etc. ###

  def self.horiz_line(color = :green)
    puts "--------------------------------------------------".colorize(color)
  end

### END Instance Methods ###

end
