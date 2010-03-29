class VoteName
  @@forename = ''
  @@surname = ''
  @@title = ''
  @@constituency = ''
  
  def initialize(input_string)
    @@constituency = get_constituency(input_string)
    
    parts = input_string.split(",")
    
    @@surname = parts[0].strip
    forename_title = parts[1].split(" ")
    if forename_title.length > 1
      @@forename = forename_title.pop
      @@title = forename_title.join(" ").strip
    else
      @@forename = forename_title[0].strip
    end
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
  
  def constituency
    @@constituency
  end
  
  
  private
    def get_constituency input_string
      if input_string =~ /\(([^\)]*)\)*/
        constituency = $1
        input_string.gsub!(/\(([^\)]*)\)*/, "")
        input_string.strip!
        return expand_constituency_name(constituency)
      end
      ""
    end
    
    def expand_constituency_name name
      case name
        when "Manch'r"
          "Manchester"
        else
          name
      end
    end
end