require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open "http://kursdollar.net/")
table_rows = doc.css 'div.col-md-8 tr'

tds = table_rows[1].xpath 'td'
banks = []
tds.each do |td|
  if td.attributes["colspan"] != nil
    span = td.xpath("@colspan").first.value.to_i
    span.times {|i| banks << td.text.strip}
  else
    banks << td.text.strip
  end
end
p banks

tds = table_rows[2].xpath 'td'
updates = []
tds.each do |td|
  if td.attributes["colspan"] != nil
    span = td.xpath("@colspan").first.value.to_i
    span.times {|i| updates << "#{td.children[0].text.strip} #{td.children[2].text.strip}"}
  else
    updates << "#{td.children[0].text.strip} #{td.children[2].text.strip}"
  end
end
p updates


dollars = { beli: [], jual: []}
tds = table_rows[4].xpath 'td'
tds.each do |td|
  if td.attributes["rowspan"] == nil
    dollars[:beli] << td.text.strip
  end
end
dollars[:beli].shift

tds = table_rows[5].xpath 'td'
tds.each do |td|
  if td.attributes["rowspan"] == nil
    dollars[:jual] << td.text.strip
  end
end
dollars[:jual].shift
p dollars
