require 'parser'

describe "The Parser" do
  
  describe "given VoteName 'Aird, John'" do
      
    before do    
      @vote_name = VoteName.new("Aird, John")
    end
  
    it "should return a forename of 'John' from a vote name of 'Aird, John'" do
      @vote_name.forename.should == "John"  
    end
  
    it "should return a surname of 'Aird' from a vote name of 'Aird, John'" do
      @vote_name.surname.should == "Aird"  
    end
  
  end

  
  describe "given VoteName 'Arrol, Sir William'" do
      
    before do    
      @vote_name = VoteName.new("Arrol, Sir William")
    end
  
    it "should return a forename of 'John' from a vote name of 'Aird, John'" do
      @vote_name.forename.should == "John"  
    end
  
    it "should return a surname of 'Aird' from a vote name of 'Aird, John'" do
      @vote_name.surname.should == "Aird"  
    end
  
  end
  
end


