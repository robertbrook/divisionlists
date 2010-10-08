require 'nokogiri'
require 'json'
require 'rest_client'
require 'htmlentities'
require "#{File.dirname(__FILE__)}/vote_name"
require 'logger'

class Html2Json
  DBSERVER = "http://localhost:5984"
  DATABASE = "#{DBSERVER}/divisionlists"
  
  def initialize
    @log = Logger.new(STDOUT)
  end

  def load_data files=nil
    @error_log = ErrorLog.new("#{File.dirname(__FILE__)}/../dataload.log")
    unless files
      paths = Dir.glob("#{File.dirname(__FILE__)}/./../data/*/*.html")
      paths += Dir.glob("#{File.dirname(__FILE__)}/./../data/*/*/*.html")
      paths += Dir.glob("#{File.dirname(__FILE__)}/./../data/*/*/*/*.html")
      paths += Dir.glob("#{File.dirname(__FILE__)}/./../data/*.html")
      paths.each do |html_file|
        load_divisions_list(html_file)
      end
    else
      files.each do |html_file|
        load_divisions_list(html_file)
      end
    end
    @error_log.close()
  end
  
  private
  
    def load_divisions_list html_file
      nokogiri_doc = Nokogiri::HTML(open(html_file))

      @log.info("opening file: " + html_file)
      nokogiri_doc.xpath('//div[@class="division-list"]').each do |division_list|
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
          error_occured = false
          
          divnum = number.text.gsub("l","1").gsub(/[^\d+]/,'')
          #use the filename (minus the extension) plus the division number as the document id
          uuid = "#{html_file[html_file.rindex('/')+1..html_file.length].gsub('.html','')}-#{divnum}"          
          uuid = uuid.gsub('.','').gsub(' ','').gsub(',','').gsub('data/', '').gsub('/','')
          
          division_hash["page"] = page.text
          
          if date.count > 1
            division_hash["date"] = date.first.text
          else
            division_hash["date"] = date.text
          end
      
          #construct the date values
          year, month, day = construct_date_values(division_hash["date"], uuid, divnum, current_file)

          division_hash["numeric_date"] = [year.to_i, month, day.to_i]
      
          division_hash["number"] = divnum
          division_hash["resolution"] = resolution.text
      
          ayes_array = []
          
          ayes_markup_fix = false
          if ayes.count == 0
            message = "division #{divnum} - ayes data missing"
            if noes.count == 2
              message = "#{message}, assuming the first noes block is in fact ayes"
              write_to_log(current_file, message)
              ayes = division_list.xpath('ol[@class="noes"]')[0]
              noes = division_list.xpath('ol[@class="noes"]')[1]
              ayes_markup_fix = true
            else
              write_to_log(current_file, message, "error")
              error_occured = true
            end
          end
          
          if noes.count == 0
            message = "division #{divnum} - noes data missing"
            write_to_log(current_file, message, "error")
            error_occured = true
          end
          
          unless error_occured
            ayes.xpath('./li').each do |aye|
              if aye.text.strip == ""
                message = "division #{divnum} - member name \"#{aye.text.strip}\" missing, member data not loaded"
                write_to_log(current_file, message)
              else
                unless aye.text.strip.include?(",")
                  message = "division #{divnum} - member name \"#{aye.text.strip}\" does not include a comma, attempting to load anyway"
                  write_to_log(current_file, message)
                end
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
            end
            
            if ayes_markup_fix
              division_hash["ayes_tellers"] = ayes.next_sibling().text
            else            
              ayes_first = ayes.first
              if ayes_first
                division_hash["ayes_tellers"] = ayes_first.next_sibling().text
              end
            end
            
            noes_array = []
            
            noes.xpath('./li').each do |noe|
              if noe.text.strip == ""
                message = "division #{divnum} - member name \"#{noe.text.strip}\" missing, member data not loaded"
                write_to_log(current_file, message)
              else
                unless noe.text.strip.include?(",")
                  message = "division #{divnum} - member name \"#{noe.text.strip}\" does not include a comma, attempting to load anyway"
                  write_to_log(current_file, message)
                end
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
            end
            
            if ayes_markup_fix
              division_hash["noes_tellers"] =  noes.next_sibling().text
            else
              noes_first = noes.first
              if noes_first
                if noes_first.next_sibling()
                  division_hash["noes_tellers"] =  noes_first.next_sibling().text
                end
              end
            end
          end

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

    def write_to_log current_file, message, level="warn"
      @error_log.log_error(current_file, message, level)
      @log.info("writing dataload.log file")
    end

    def log_error current_file, ref, item_name, item
      message = "#{ref} - #{item_name} count was #{item.count}, expected 1"
      write_to_log(current_file, message)  
      @log.info(message)
    end

    def get_month_num month_name
      case month_name.downcase
        when "january", "ianuarius"
          1
        when "february", "februarii", "februarius"
          2
        when "march", "martii", "martius"
          3
        when "april", "aprilis"
          4
        when "may", "maii", "maius"
          5
        when "june", "junii", "iunius"
          6
        when "july", "julii", "julius"
          7
        when "august", "augusti", "sextilis"
          8
        when "september"
          9
        when "october"
          10
        when "november"
          11
        when "december"
          12
      end
    end

    def do_error_check page, date, number, resolution, ayes, noes, current_file
      if number.count == 1
        #we can have more detailed error messages, yay!
        error_ref = "division #{number.text} - "
      elsif page.count == 1
        #failover reference point
        error_ref = "page #{page.text} - "
      else
        #no idea where this happened
        error_ref = ""
      end
  
      unless page.count > 0
        message = "#{error_ref}found #{page.count} pages, expected at least 1"
        write_to_log(current_file, message)
      end
  
      unless date.count == 1
        message = "#{error_ref}found #{date.count} dates, expected to find 1"
        write_to_log(current_file, message)
      end
  
      if number.count < 1
        unless error_ref == ""
          message = "Division at #{error_ref}no division number"
        else
          message = "No division number found"
        end
        write_to_log(current_file, message, "error")
        error_occured = true
      else
        divnum = number.text.squeeze(" ").gsub("Number", "").gsub("Numb","").gsub("Namb","").gsub("Num","").gsub("???umb", "").gsub(".", "").gsub(",", "").strip
        unless divnum =~ /^\d+$/
          divnum = divnum.gsub("l", "1")
          unless error_ref == ""
            message = "Division at #{error_ref}division number not numeric"
          else
            message = "Division number #{divnum} not numeric"
          end
          if divnum =~ /^\d+$/
            message = "#{message}, replaced with #{divnum}"
            number = divnum
            write_to_log(current_file, message)
          else
            write_to_log(current_file, message, "error")
            error_occured = true
          end
        end
      end
  
      if resolution.count < 1
        message = "#{error_ref}no resolution text found"
        write_to_log(current_file, message, "error")
        error_occured = true
      else
        if resolution.text.include?("???")
          message = "#{error_ref}resolution text contains invalid characters"
          write_to_log(current_file, message)
        end
      end
  
      return error_occured
    end
    
    def construct_date_values(date, uuid, division, current_file)
      error_reported = false
      message = "division #{division} - incomplete date, date implied from filename"
      
      escaped_text = HTMLEntities.new.encode(date)
      escaped_text.gsub!("\302\260", "")
  
      date_parts = escaped_text.split(",")
  
      year = date_parts.pop
      unless year.nil?
        year = year.gsub(".", "").strip
      end
      
      if year.nil?
        #data may be missing, imply it from the uuid
        unless error_reported 
          write_to_log(current_file, message)
          error_reported = true
        end
        parts = uuid.split("-")
        year = parts[0].to_i
      else          
        unless year.length == 4
          #something's wrong here!
          write_to_log(current_file, "division #{division} - date format error, attempting to recover")
          parts = year.split(" ")
          year = parts.pop.gsub(".", "").strip
          date_parts << parts.join(" ")
        end
      end
  
      month_day = date_parts.pop
      if month_day.nil?
        month = nil
        
        #imply day from uuid
        unless error_reported
          write_to_log(current_file, message)
          error_reported = true
        end
        parts = uuid.split("-")
        day = parts[2]
      else
        month_day = month_day.split(" ")
        month = month_day.pop
        if month.nil?
          #data may be missing, imply it from the uuid
          unless error_reported
            write_to_log(current_file, message)
            error_reported = true
          end
          parts = uuid.split("-")
          month = parts[1].to_i
        else
          month.strip!
          month = get_month_num(month)
        end
      end
      
      if month.nil?
        #data may be missing, imply it from the uuid
        unless error_reported
          write_to_log(current_file, message)
          error_reported = true
        end
        parts = uuid.split("-")
        month = parts[1].to_i
      end
      
      unless month_day.nil?
        day = month_day.join(" ").match(/\d+/).to_s
        if day.to_i == 0
          #data may be missing, imply it from the uuid
          unless error_reported
            write_to_log(current_file, message)
            error_reported = true
          end
          parts = uuid.split("-")
          day = parts[2]
        end
      end
      [year, month, day]
    end
end


class ErrorLog
  def initialize(log_file)
    @data_file = ""
    @log_file = File.open("#{log_file}", 'a')
  end
  
  def log_error(data_file, message, level="warn")
    if @data_file == ""
      @log_file.write("**********************************\n* #{Time.now} *\n**********************************")
    end
    
    unless @data_file == data_file
      @log_file.write("\n\nFile #{data_file}:\n")
    end
    @data_file = data_file
    
    @log_file.write("  #{level.upcase()} #{message}\n")
  end
  
  def close
    @log_file.write("\n\n")
    @log_file.close
  end
end