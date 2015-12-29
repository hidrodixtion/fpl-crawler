require 'nokogiri'
require 'open-uri'

p Time.now.strftime("%H : %M")

# get ids
ids = []
doc = Nokogiri::HTML(open("http://id.fantasy.premierleague.com/my-leagues/690749/standings/"))
table = doc.css('table.ismTable tr, table.ismStandingsTable tr')
table.collect do |row|
  unless row.xpath('td[3]/a/@href').text.strip.to_s.empty?
    id = {}
    id[:name] = row.xpath('td[3]').text.strip
    id[:url] = row.xpath('td[3]/a/@href').text.strip
    id[:last_point] = row.xpath('td[6]').text.strip
    ids.push id
  end
end

# uncomment 2 lines below to limit array (for testing purpose)
# set = *(2..ids.length)
# ids.delete_if.with_index {|_, index| set.include? index}

# get latest point
ids.each do |id|
  doc = Nokogiri::HTML(open("http://id.fantasy.premierleague.com#{id[:url]}"))
  doc.xpath("//div[contains(@class, 'ism-scoreboard-panel__points')]").collect do |node|
    id[:gw_point] = node.text.strip.gsub(/[poin]/, '')

    # won't work if score already updated
    id[:total_point] = id[:last_point] + id[:gw_point]
  end
end

# print only latest score (& sort it)
ids.sort_by! {|hash| hash[:gw_point]}
ids.reverse!
ids.each {|hash| p "#{hash[:name]} : #{hash[:gw_point]}"}

p Time.now.strftime("%H : %M")