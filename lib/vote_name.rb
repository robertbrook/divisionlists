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
      parts = input_string.split(",").reverse
      surname = parts.pop.strip

      input_string = parts.reverse.join(",")

      parts = input_string.split(" ")

      last_piece = parts.pop
      if last_piece.strip =~ /\-$/
        surname = "#{last_piece}#{surname}"
      else
        parts << last_piece
      end
      
      input_string = parts.join(" ")
      
      [surname, input_string]
    end
    
    def get_title input_string
      parts = input_string.split(" ")
      title = ""
      
      case input_string
        when /(Sir)/, /(Lieut\.-Col\.)/, /(Lieut\.-General)/, /(Lord)/, /(Viscount)/, /(Colonel)/, 
          /(Commander)/, /(Major)/, /(Earl(?: of*))/, /(Lt\.-Col\.)/, /(Col\.)/, /(Captain)/, /(Dr\.)/
          title = $1
          input_string.gsub!($1, "")
      end
      
      [title, input_string]
    end
    
    def get_ministerial_title input_string
      parts = input_string.split(" ")
      title = ""
      
      case input_string
        when /(Rt\.\ *Hon\.)/, /(Rt(?:\.)\ *Hn\.)/, /(Hon\.)/, /(RtHn\.)/
          title = $1
          input_string.gsub!($1, "")
      end
      
      [title, input_string]
    end
    
    def get_forename(input_string)
      names = input_string.scan(/[A-Z](?:[^A-Z]*)/)      
      forename = names.join(" ")
      forename = expand_forename(forename)
      forename.squeeze(" ").strip
    end
    
    def expand_constituency_name name
      case name
        when "Manch'r"
          "Manchester"
        when "Yorks."
          "Yorkshire"
        when "Hunts."
          "Huntingdon"
        when "Birm."
          "Birmingham"
        else
          name
      end
    end
    
    def expand_forename name
      name.gsub!("Wm.", "William")
      name.gsub!("Geo.", "George")
      name.gsub!("Edw.", "Edward")
      name
    end
end