# fpl-crawler
This is a raw experiment to crawl team point in [Fantasy Premier League](fantasy.premierleague.com). This is based on Bahasa Indonesia version of FPL. If you're using English as FPL language, change line 28 :
    
    id[:gw_point] = node.text.strip.gsub(/[poin]/, '')
to
    
    id[:gw_point] = node.text.strip.gsub(/[point]/, '')
# requirements
- nokogiri
- open-uri
