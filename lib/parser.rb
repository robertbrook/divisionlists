class VoteName
  @@forename = ''
  @@surname = ''
  @@title = ''
  
  def initialize(input_string)
    parts = input_string.split(",")
    @@forename = parts[1].strip
    @@surname = parts[0].strip
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
end

