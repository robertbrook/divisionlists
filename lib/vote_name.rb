class VoteName
  @@forename = ''
  @@surname = ''
  @@title = ''
  @@constituency = ''
  
  def initialize(input_string)
    @@constituency = get_constituency(input_string)
    
    parts = input_string.split(",").reverse
    @@surname = parts.pop.strip
    
    input_string = parts.reverse.join(",")
    
    parts = input_string.split(" ")
    if parts.length > 1
      @@forename = parts.pop
      @@title = parts.join(" ").strip
    else
      @@forename = parts[0].strip
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