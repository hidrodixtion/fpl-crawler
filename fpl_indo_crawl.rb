require 'nokogiri'
require 'open-uri'
require 'watir'
require 'yaml'
#p Time.now.strftime("%H : %M")

@ids = []

def init  
  if File.exist?("fpl_ids.yml")
    @ids = YAML.load_file "fpl_ids.yml"
  else
    scrape_ids()
  end

  scrape_points()
end

# get ids
def scrape_ids
  browser = Watir::Browser.new(:chrome, headless: false)
  browser.goto "https://fantasy.premierleague.com/a/leagues/standings/167055/classic"

  doc = Nokogiri::HTML.parse(browser.html)
  table = doc.css("table.ism-table tr")

  table.each do |row|
    player = row.css('a.ismjs-link')
    unless player.text.strip.to_s.empty?
      id = {}

      player.map do |info|
        id[:name] = info.xpath('strong').text
        id[:url] = info['href']
      end  
      
      @ids << id
    end
  end

  File.open("fpl_ids.yml", "w+") do |file|
    file.write @ids.to_yaml
  end 
end

def scrape_points
  @ids.each do |id|
    get_point id 
  end
end

def get_point(id, browser = nil)
  url = "https://fantasy.premierleague.com#{id[:url]}"
  
  if browser == nil
    browser = Watir::Browser.new(:chrome, headless: true)
  end
  
  browser.goto url # "https://fantasy.premierleague.com/#{id[:url]}/event/4"
  doc = Nokogiri::HTML.parse(browser.html)

  point_path = doc.css("div.ism-scoreboard__panel__value.ism-scoreboard__panel__value--lrg")

  id[:gw_point] = point_path.text.strip.split("\n")[0]
  if id[:gw_point] == nil
    get_point(id, browser)
  else
    p id

    browser.close
  end
end

init()

#p Time.now.strftime("%H : %M")