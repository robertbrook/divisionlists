require 'rubygems'
require 'nokogiri'
require 'json'
require './couch.rb'

server = Couch::Server.new("localhost", "5984")
database = "divisionlists"

Dir.glob('./data/*.html').each do |html_file|
  nokogiri_doc = Nokogiri::HTML(open(html_file))
    
    nokogiri_doc.xpath('//div[@class="division-list"]').each do |division_list|
      division_hash = {}
      
      filename = html_file.split("/").last
      division_hash["file"] = filename
      
      division_hash["page"] = division_list.xpath('p[@class="page"]').text
      division_hash["date"] = division_list.xpath('p[@class="date"]').text
      division_hash["number"] = division_list.xpath('p[@class="divnum"]').text
      division_hash["resolution"] = division_list.xpath('p[@class="resolution"]').text
            
      ayes_array = []
      division_list.xpath('ol[@class="ayes"]/li').each do |aye|
        ayes_array << aye.text.strip
      end
      division_hash["ayes"] = ayes_array
            
      ayes_first = division_list.xpath('ol[@class="ayes"]').first
      if ayes_first
        division_hash["ayes_tellers"] = ayes_first.next_sibling().text
      end
      
      noes_array = []
      division_list.xpath('ol[@class="noes"]/li').each do |noe|
        noes_array << noe.text.strip
      end
      division_hash["noes"] = noes_array
      
      noes_first = division_list.xpath('ol[@class="noes"]').first
      if noes_first
        division_hash["noes_tellers"] =  noes_first.next_sibling().text
      end
      
      #get the database to generate a valid UUID
      result = server.get("/_uuids")
      values = JSON.parse(result.body)
      uuid = values["uuids"].first
      
      #convert the hash into a valid JSON doc
      doc = <<-JSON
      #{JSON.generate(division_hash)}
      JSON
      
      #PUT the new record to the database
      server.put("/#{database}/#{uuid}", doc)
      #optionally could check the result is 201 Created...
    end
    
end



