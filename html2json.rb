require 'rubygems'
require 'nokogiri'
require 'json'
require 'rest_client'

DBSERVER = "http://localhost:5984"
DATABASE = "#{DBSERVER}/divisionlists"

def get_uuid
  result = RestClient.get("#{DBSERVER}/_uuids")
  values = JSON.parse(result.body)
  values["uuids"].first
end

def write_to_log message
  File.open("./dataload.log", 'a') {|f| f.write(message) }
end

def log_error current_file, ref, item_name, item
  message = "error in file #{current_file}#{ref} - #{item_name} count was #{item.count}, expected 1\n"
  write_to_log(message)  
end

def load_divisions_list html_file
  nokogiri_doc = Nokogiri::HTML(open(html_file))
  
  nokogiri_doc.xpath('//div[@class="division-list"]').each do |division_list|
    error_occured = false
    
    division_hash = {}
  
    current_file = html_file.split("/").last
    division_hash["file"] = current_file
  
    page = division_list.xpath('p[@class="page"]')
    date = division_list.xpath('p[@class="date"]')
    number = division_list.xpath('p[@class="divnum"]')
    resolution = division_list.xpath('p[@class="resolution"]')
    ayes = division_list.xpath('ol[@class="ayes"]')
    noes = division_list.xpath('ol[@class="noes"]')
    
    error_ref = ""
    if number.count == 1
      #we can have more detailed error messages, yay!
      error_ref = " in divisionlist #{number.text}"
    elsif page.count == 1
      #failover reference point
      error_ref = " referring to page #{page.text}"
    else
      #no idea where this happened
      error_ref = ""
    end    
    
    unless page.count == 1
      log_error current_file, error_ref, "page", page
      error_occured = true
    end
    
    unless date.count == 1
      log_error current_file, error_ref, "date", date
      error_occured = true
    end
    
    unless number.count == 1
      log_error current_file, error_ref, "number", number
      error_occured = true
    else
      divnum = number.text.gsub("Numb", "").gsub(".", "").gsub(",", "").strip
      unless divnum =~ /^\d+$/
        message = "error in file #{current_file}#{error_ref} - division number #{divnum} may be invalid\n"
        write_to_log message
        error_occured = true
      end
    end
    
    unless ayes.count == 1
      log_error current_file, error_ref, "ayes", ayes
      error_occured = true
    end
    
    unless noes.count == 1
      log_error current_file, error_ref, "noes", noes
      error_occured = true
    end
    
    unless resolution.count == 1
      log_error current_file, error_ref, "resolution", resolution
      error_occured = true
    end
    
    unless error_occured
      division_hash["page"] = page.text
      division_hash["date"] = date.text
      division_hash["number"] = number.text
      division_hash["resolution"] = resolution.text
      
      ayes_array = []
      ayes.xpath('/li').each do |aye|
        ayes_array << aye.text.strip
      end
      division_hash["ayes"] = ayes_array
      
      ayes_first = ayes.first
      if ayes_first
        division_hash["ayes_tellers"] = ayes_first.next_sibling().text
      end

      noes_array = []
      noes.xpath('/li').each do |noe|
        noes_array << noe.text.strip
      end
      division_hash["noes"] = noes_array

      noes_first = noes.first
      if noes_first
        division_hash["noes_tellers"] =  noes_first.next_sibling().text
      end
    
      uuid = get_uuid()

      #convert the hash into a valid JSON doc
      doc = <<-JSON
      #{JSON.generate(division_hash)}
      JSON

      #PUT the new record to the database
      RestClient.put("#{DATABASE}/#{uuid}", doc)
    end
  end
end

def load_data
  write_to_log("#{Time.now}\n")
  Dir.glob('./data/*.html').each do |html_file|
    load_divisions_list(html_file)
  end
  write_to_log("\n")
end

load_data()