# #### CURRENTLY UNUSED!!! ####
#
# class Artist
#   # extend Concerns::Findable
#   attr_accessor :name, :shows
#
#   @@all = []
#
# ### FINDABLE methods.  (To be put in a module) ###
#   # remove the self. prefix for module
#   def self.find_by_name(name)
#     self.all.detect {|object| object.name == name}
#   end
#
#   def self.find_or_create_by_name(name)
#     return self.find_by_name(name) if self.find_by_name(name) # if artist is found, return it.
#     # otherwise, create it
#     self.create(name)
#   end
# ### END FINDABLE METHODS ###
#
#   def initialize(name)
#     @name = name
#     @shows = []
#   end
#
#   def self.all
#     @@all
#   end
#
#   def self.destroy_all
#     self.all.clear
#   end
#
#   def save
#     self.class.all << self
#   end
#
#   def self.create(name)
#     new_artist = self.new(name)
#     new_artist.save
#     new_artist
#   end
#
#   def add_show(show)
#     self.shows << show if !(self.shows.include?(show))
#     #  the !(show.artist == self) is a way to prevent an infinite loop
#     #  need to either shovel << or add this artist to a show's bands if
#     show.bands << self if !(show.bands.include?(self))
#   end
# end
