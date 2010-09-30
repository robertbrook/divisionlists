require 'rubygems'
require 'nokogiri'
require 'json'
require 'rest_client'
require 'htmlentities'
require "#{File.dirname(__FILE__)}/vote_name"
require 'logger'

class Html2Json
  DBSERVER = "http://localhost:5984"
  DATABASE = "#{DBSERVER}/divisionlists"

  def load_data
    @log = Logger.new(STDOUT)
    write_to_log("#{Time.now}\n")
    paths = Dir.glob("#{File.dirname(__FILE__)}/./../data/*/*.html")
    paths += Dir.glob("#{File.dirname(__FILE__)}/./../data/*/*/*.html")
    paths += Dir.glob("#{File.dirname(__FILE__)}/./../data/*/*/*/*.html")
    paths += Dir.glob("#{File.dirname(__FILE__)}/./../data/*.html")
    paths.each do |html_file|
      load_divisions_list(html_file)
    end
    write_to_log("\n")
  end
  
  def load_divisions_list html_file
    nokogiri_doc = Nokogiri::HTML(open(html_file))

    @log.info("opening file: " + html_file)
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
    
      unless do_error_check(page, date, number, resolution, ayes, noes, current_file)
        division_hash["page"] = page.text
        division_hash["date"] = date.text
      
        escaped_text = HTMLEntities.new.encode(date.text)
        escaped_text.gsub!("\302\260", "")
      
        date_parts = escaped_text.split(",")
      
        year = date_parts.pop.gsub(".", "").strip
      
        month_day = date_parts.pop.split(" ")
        month = month_day.pop.strip
        month = get_month_num(month)
          
        day = month_day.join(" ").match(/\d+/).to_s

        division_hash["numeric_date"] = [year, month, day]
      
        division_hash["number"] = number.text
        division_hash["resolution"] = resolution.text
      
        ayes_array = []
        ayes.xpath('./li').each do |aye|
          member_hash = {}
          vote_name = VoteName.new(aye.text.strip)
          member_hash["parliamentary_title"] = vote_name.parliamentary_title
          member_hash["title"] = vote_name.title
          member_hash["forename"] = vote_name.forename
          member_hash["surname"] = vote_name.surname
          member_hash["constituency"] = vote_name.constituency
          member_hash["division_name"] = aye.text.strip
          ayes_array << member_hash
        end
        division_hash["ayes"] = ayes_array
      
        ayes_first = ayes.first
        if ayes_first
          division_hash["ayes_tellers"] = ayes_first.next_sibling().text
        end

        noes_array = []
        noes.xpath('./li').each do |noe|
          member_hash = {}
          vote_name = VoteName.new(noe.text.strip)
          member_hash["parliamentary_title"] = vote_name.parliamentary_title
          member_hash["title"] = vote_name.title
          member_hash["forename"] = vote_name.forename
          member_hash["surname"] = vote_name.surname
          member_hash["constituency"] = vote_name.constituency
          member_hash["division_name"] = noe.text.strip
          noes_array << member_hash
        end
        division_hash["noes"] = noes_array

        noes_first = noes.first
        if noes_first
          if noes_first.next_sibling()
            division_hash["noes_tellers"] =  noes_first.next_sibling().text
          end
        end
      
        #use the filename (minus the extension) plus the division number as the document id
            
        uuid = "#{html_file[html_file.rindex('/')+1..html_file.length].gsub('.html','')}-#{number.text.gsub('Numb','')}"
        uuid = uuid.gsub('.','').gsub(' ','').gsub(',','').gsub('data/', '').gsub('/','')

        #convert the hash into a valid JSON doc
        doc = <<-JSON
        #{JSON.generate(division_hash)}
        JSON


        begin
          @log.info("putting " + doc)
          #PUT the new record to the database
          RestClient.put("#{DATABASE}/#{uuid}", doc)
        rescue RestClient::Conflict
          @log.info("got a duplicate!")
          #duplicate record, ignore
        end
      end
    end
  end

  def write_to_log message
    File.open("#{File.dirname(__FILE__)}/../dataload.log", 'a') {|f| f.write(message) }
    @log.info("writing dataload.log file")
  end

  def log_error current_file, ref, item_name, item
    message = "error in file #{current_file}#{ref} - #{item_name} count was #{item.count}, expected 1\n"
    write_to_log(message)  
    @log.info(message)
  end

  def get_month_num month_name
    case month_name.downcase
      when "january", "ianuarius"
        "01"
      when "february", "februarii", "februarius"
        "02"
      when "march", "martii", "martius"
        "03"
      when "april", "aprilis"
        "04"
      when "may", "maii", "maius"
        "05"
      when "june", "junii", "iunius"
        "06"
      when "july", "julii", "julius"
        "07"
      when "august", "augusti", "sextilis"
        "08"
      when "september"
        "09"
      when "october"
        "10"
      when "november"
        "11"
      when "december"
        "12"
    end
  end

  def do_error_check page, date, number, resolution, ayes, noes, current_file
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
    else
      ayes.xpath('./li').each do |member|
        unless member.text.include?(",")
          message = "error in file #{current_file}#{error_ref} - member name #{member.text.strip} did not include a comma\n"
          write_to_log message
          error_occured = true
        end
      end
    end
  
    unless noes.count == 1
      log_error current_file, error_ref, "noes", noes
      error_occured = true
    else
      noes.xpath('./li').each do |member|
        unless member.text.include?(",")
          message = "error in file #{current_file}#{error_ref} - member name #{member.text.strip} did not include a comma\n"
          write_to_log message
          error_occured = true
        end
      end
    end
  
    unless resolution.count == 1
      log_error current_file, error_ref, "resolution", resolution
      error_occured = true
    else
      if resolution.text.include?("???")
        message = "error in file #{current_file}#{error_ref} - resolution text contains invalid characters\n"
        write_to_log message
        error_occured = true
      end
    end
  
    return error_occured
  end
end