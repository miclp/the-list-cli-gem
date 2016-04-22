

class Artist
  # extend Concerns::Findable
  attr_accessor :name, :shows

  @@all = []

  def initialize(name)
    @name = name
    @shows = []
  end

  def self.all
    @@all
  end

  def self.destroy_all
    self.all.clear
  end

  def save
    self.class.all << self
  end

  def self.create(name)
    new_artist = self.new(name)
    new_artist.save
    new_artist
  end

  def add_show(show)
    self.shows << show if !(self.shows.include?(show))
    #  the !(show.artist == self) is a way to prevent an infinite loop
    #  need to either shovel << or add this artist to a show's bands if
    show.bands << self if !(show.bands.include?(self))
  end



end
