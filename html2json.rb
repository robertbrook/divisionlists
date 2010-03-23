require 'rubygems'
require 'nokogiri'

html_files = Dir.glob('./data/*.html')

html_files.each do |html_file|
  doc = Nokogiri::HTML(open(html_file))
    
    doc.xpath('//div[@class="division-list"]').each do |division_list|
      division_hash = {}
      
      division_hash["page"] = division_list.xpath('p[@class="page"]').text
      division_hash["date"] = division_list.xpath('p[@class="date"]').text
      division_hash["number"] = division_list.xpath('p[@class="divnum"]').text
      division_hash["resolution"] = division_list.xpath('p[@class="resolution"]').text
            
      division_list.xpath('ol[@class="ayes"]/li').each do |aye|
        p "Aye: " + aye.text.strip
      end
            
      if division_list.xpath('ol[@class="ayes"]').first
        division_hash["ayes_tellers"] =  division_list.xpath('ol[@class="ayes"]').first.next_sibling().text
      end
      
      division_list.xpath('ol[@class="noes"]/li').each do |noe|
        p "Noe: " + noe.text.strip
      end
      
      if division_list.xpath('ol[@class="noes"]').first
        division_hash["noes_tellers"] =  division_list.xpath('ol[@class="noes"]').first.next_sibling().text
      end
      
      p division_hash
      
    end
    
end



