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
  id = @ids[0]

  # ids.each do |id|
  url = "https://fantasy.premierleague.com#{id[:url]}"
  browser = Watir::Browser.new(:chrome, headless: false)
  browser.goto url # "https://fantasy.premierleague.com/#{id[:url]}/event/4"
  doc = Nokogiri::HTML.parse(browser.html)

  point_path = doc.css("div.ism-scoreboard-points")
  p doc.css("ism-scoreboard__panel__value")
  # p doc.css("div.ism-scoreboard-points")
  # p doc
  # id[:gw_point] = point_path.text.strip
# end
end

init()



# p ids
# uncomment 2 lines below to limit array (for testing purpose)
# set = *(2..ids.length)
# ids.delete_if.with_index {|_, index| set.include? index}

# get latest point
# ids.each do |id|
#   doc = Nokogiri::HTML(open("http://id.fantasy.premierleague.com#{id[:url]}"))
#   doc.xpath("//div[contains(@class, 'ism-scoreboard-panel__points')]").collect do |node|
#     id[:gw_point] = node.text.strip.gsub(/[poin]/, '').to_i

#     # won't work if score already updated / will be updated
#     id[:total_point] = id[:last_point] + id[:gw_point]# - id[:not_updated_gw_point]
#   end
# end

# # print only latest score (& sort it)
# ids.sort_by! {|hash| hash[:gw_point]}
# ids.reverse!
# ids.each {|hash| p "#{hash[:name]} : #{hash[:gw_point]}"}
# p "------"
# ids.sort_by! {|hash| hash[:total_point]}
# ids.reverse!
# ids.each {|hash| p "#{hash[:name]} : #{hash[:total_point]}"}

#p Time.now.strftime("%H : %M")