# Show objects (concert objects)


class Show

  attr_accessor :shows

  def initialize()
  end

  def self.create_from_collection(shows)
    @@shows = shows
  end

end
