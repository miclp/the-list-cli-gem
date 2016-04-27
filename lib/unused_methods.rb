####

### from command_line_interface.rb

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

##### from scraper.rb
#################################################################

# for working/debugging only
def self.pry_index_page(index_url)
  index_page = Nokogiri::HTML(open(index_url))
  binding.pry
  index_page
end

def self.pry_show_page(show_url)
  show_page = Nokogiri::HTML(open(show_url))
  binding.pry
  show_page
end

# Create a temp file (that can be loaded later)
def self.create_local_temp_file(index_url)
  index_page = Nokogiri::HTML(open(index_url))
  newfile = File.open("temp", "w")

  newfile.write(index_page)
  newfile.close
end

# doesn't work
def self.open_local_file(path_to_file)
  noko_file = Nokogiri::HTML(open(path_to_file))
  # noko_file = File.open(path_to_file)
  binding.pry
  # syntax from nokogiri docs:
  # noko_file = File.open(path_to_file) { |f| Nokogiri::HTML(f) }
end
