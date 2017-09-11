require 'nokogiri'
require 'open-uri'

p "BCA"

# doc = Nokogiri::HTML(open "http://www.bca.co.id/id/Individu/Sarana/Kurs-dan-Suku-Bunga/Kurs-dan-Kalkulator")
# table_rows = doc.css 'tbody.text-right tr'
# table_rows.each do |row|
#   tds = row.xpath('td')
#   arrcol = []
#   tds.each do |column|
#     arrcol << column.text.strip
#   # p [row.xpath('td[1]').text.strip, row.xpath('td[2]').text.strip, row.xpath('td[3]').text.strip]
#   end
#   p arrcol
# end

p "MANDIRI"

doc = Nokogiri::HTML(open "http://www.bankmandiri.co.id/resource/kurs.asp")
table_rows = doc.css 'table.tbl-view tr'
table_rows.shift
table_rows.each do |row|
  tds = row.xpath 'td'
  arrcol = []

  next if tds.size < 6

  (tds.size-1).times do |i|
    if i == 1 || i == 2 || i == 4
      arrcol << tds[i].text.strip
    end
  end

  p arrcol
end
