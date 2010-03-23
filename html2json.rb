require 'rubygems'
require 'nokogiri'

html_files = Dir.glob('./data/*.html')

html_files.each do |html_file|
  doc = Nokogiri::HTML(open(html_file))
    
    doc.xpath('//div[@class="division-list"]').each do |division_list|
      
      p "A DIVISION!"
      p "Page: " + division_list.xpath('p[@class="page"]').text
      p "Date: " + division_list.xpath('p[@class="date"]').text
      p "Number: " + division_list.xpath('p[@class="divnum"]').text
      p "Resolution: " + division_list.xpath('p[@class="resolution"]').text
      
      
      division_list.xpath('ol[@class="ayes"]/li').each do |aye|
        p "Aye: " + aye.text.strip
      end
      
      if division_list.xpath('ol[@class="ayes"]')
        p "(Ayes Tellers) " + division_list.xpath('ol[@class="ayes"]').first.next_sibling().text
      end
      
      division_list.xpath('ol[@class="noes"]/li').each do |noe|
        p "Noe: " + noe.text.strip
      end
      
      if division_list.xpath('ol[@class="noes"]')
        p "(Noes Tellers) " + division_list.xpath('ol[@class="noes"]').first.next_sibling().text
      end
      
      p ""
      
    end
    
end



