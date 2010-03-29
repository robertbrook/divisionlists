class VoteName
  @@forename = ''
  @@surname = ''
  @@title = ''
  @@constituency = ''
  
  def initialize(input_string)
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
end

