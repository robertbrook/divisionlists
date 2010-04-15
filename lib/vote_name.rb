class VoteName
  @@forename = ''
  @@surname = ''
  @@title = ''
  @@constituency = ''
  @@ministerial_title = ''
  
  def initialize(input_string)
    @@constituency, input_string = get_constituency(input_string)
    @@surname, input_string = get_surname(input_string)
    @@title, input_string = get_title(input_string)
    @@ministerial_title, input_string = get_ministerial_title(input_string)
    @@forename = get_forename(input_string)
  end
  
  def forename
    @@forename
  end
  
  def surname
    @@surname
  end
  
  def title
    @@title
  end
  
  def ministerial_title
    @@ministerial_title
  end
  
  def constituency
    @@constituency
  end
  
  
  private
    def get_constituency input_string
      if input_string =~ /\(([^\)]*)\)*/
        constituency = $1
        input_string.gsub!(/\(([^\)]*)\)*/, "")
        input_string.strip!
        constituency =  expand_constituency_name(constituency)
      else
        constituency = ""
      end
      
      [constituency, input_string]
    end
    
    def get_surname input_string
      input_string = even_out_spacing(input_string)

      parts = input_string.split(",").reverse
      surname = parts.pop.strip

      input_string = parts.reverse.join(",")

      parts = input_string.split(" ")

      last_piece = parts.pop
      last_piece.strip! if last_piece
      if last_piece =~ /\-$/
        surname = "#{last_piece}#{surname}"
      else
        parts << last_piece
      end
            
      surname.gsub!("Mac ", "Mac")
      surname.gsub!("Mc ", "Mac")
      surname.gsub!("M ", "M")
      surname.gsub!("O ", "O")
      surname.gsub!("M' ", "M'")
      surname.gsub!("O' ", "O'")
      
      input_string = parts.join(" ")
      
      [surname, input_string]
    end
    
    def get_title input_string
      parts = input_string.split(" ")
      title = ""
      
      case input_string
        when /(Lieut\.-Col\.)/, /(Lt\.-Col\.)/
          title = "Lieutenant Colonel"
          input_string.gsub!($1, "")
        when /(Lieut\.-General)/
          title = "Lieutenant General"
          input_string.gsub!($1, "")
        when /(Colonel)/, /(Col\.)/
          title = "Colonel"
          input_string.gsub!($1, "")
        when /(Captain)/, /(Capt\.)/
          title = "Captain"
          input_string.gsub!($1, "")
        when /(Dr\.)/, /(Doctor)/
          title = "Doctor"
          input_string.gsub!($1, "")
        when /(Sir)/, /(Lord)/, /(Viscount)/, /(Commander)/, /(Major)/, /(Earl(?: of*))/
          title = $1
          input_string.gsub!($1, "")
      end
      
      [title, input_string]
    end
    
    def get_ministerial_title input_string
      parts = input_string.split(" ")
      title = ""
      
      case input_string
        when /(Rt(?:\.*)\ *Hon\.)/, /(Rt(?:\.*)\ *Hn\.)/, /(RtHn\.)/
          title = "Rt. Hon."
          input_string.gsub!($1, "")
        when /(Hon\.)/, /(Hn\.)/
          title = "Hon."
          input_string.gsub!($1, "")
      end
      
      [title, input_string]
    end
    
    def get_forename(input_string)
      forename = even_out_spacing(input_string)
      forename = expand_forename(forename)
    end
    
    def expand_constituency_name name
      #replace a dot followed by any letter with ". "
      if name =~ /\.([A-Za-z])/
        name.gsub!(/\.[A-Za-z]/, ". #{$1}")
      end
      
      #replace a comma followed by any character with ", "
      name = name.gsub(",", ", ").squeeze(" ")
      
      #assume anything with 'sh???' was supposed to end 'shire'
      if name =~ /(sh\?\?\?)$/
        name.gsub!($1, "shire")
      end
      
      #assume that 'of' followed immediately be a capital letter is a mistake
      if name =~ /of([A-Z])/
        name.gsub!(/of[A-Z]/, "of #{$1}")
      end
      
      name.gsub!("sh.", "shire")
      name.gsub!(" N.", " North")
      name.gsub!(" E.", " East")
      name.gsub!("Newc.", "Newcastle")
      
      case name
        when /Antrim,/
          name.gsub!(",", "")
        when "Beds."
          "Bedfordshire"
        when "Birm."
          "Birmingham"
        when "Heref'd"
          "Hereford"
        when "Hunts."
          "Huntingdon"
        when /^Isle of W/
          "Isle of Wight"
        when "King's L'nn"
          "King's Lynn"  
        when "Manch'r"
          "Manchester"
        when "Stockton-on-T???", "Stockton-on-Tee"
          "Stockton-on-Tees"
        when "Swn's'a"
          "Swansea"
        when "Yorks."
          "Yorkshire"
        else
          name
      end
    end
   
    def even_out_spacing input_string
      result = input_string.scan(/[A-Z](?:[^A-Z]*)/)
      result = result.join(" ")
      result = result.squeeze(" ").strip
      result.gsub("' ", "'").gsub("- ", "-")
    end
    
    def expand_forename name
      name.gsub!("Wm.", "William")
      name.gsub!("Geo.", "George")
      name.gsub!("Edw.", "Edward")
      name.gsub!("Thos.", "Thomas")
      name.gsub!("Chas.", "Charles")
      name
    end
end