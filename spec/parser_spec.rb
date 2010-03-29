require 'parser'

describe "The Parser" do
  describe "given VoteName 'Aird, John'" do
    before do    
      @john_aird = VoteName.new("Aird, John")
    end
  
    it "should return a forename of 'John'" do
      @john_aird.forename.should == "John"  
    end
  
    it "should return a surname of 'Aird'" do
      @john_aird.surname.should == "Aird"  
    end
  end

  
  describe "given VoteName 'Arrol, Sir William'" do
    before do    
      @sir_william_arrol = VoteName.new("Arrol, Sir William")
    end
  
    it "should return a forename of 'William'" do
      @sir_william_arrol.forename.should == "William"  
    end
  
    it "should return a surname of 'Arrol'" do
      @sir_william_arrol.surname.should == "Arrol"  
    end
    
    it "should return a title of 'Sir'" do
      @sir_william_arrol.title.should == "Sir"  
    end
  
  end
  
  describe "given VoteName 'Atkinson, Rt. Hon. John'" do
    before do    
      @rt_hon_john_atkinson = VoteName.new("Atkinson, Rt. Hon. John")
    end
  
    it "should return a forename of 'John'" do
      @rt_hon_john_atkinson.forename.should == "John"  
    end
  
    it "should return a surname of 'Atkinson'" do
      @rt_hon_john_atkinson.surname.should == "Atkinson"  
    end
    
    it "should not return a title"
  end
  
end


