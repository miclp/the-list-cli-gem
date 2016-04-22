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

  def self.create_from_collection(shows)
    # binding.pry
    shows.each do |show_hash|
      Show.new(show_hash)
    end
    # binding.pry
  end

  def self.all
    @@all
  end

  def self.pry_into_code
    binding.pry
  end

  def add_show_attributes(attributes_hash)
    attributes_hash.each do |key, value|
      self.send "#{key}=" , value
    end
    self
  end

end
