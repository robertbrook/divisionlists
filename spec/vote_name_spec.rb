require 'vote_name'

describe "The VoteName Parser" do
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
    
    it "should not return a title" do
      @rt_hon_john_atkinson.title.should == ""
    end
  end
  
  describe "given VoteName 'Balfour, Rt. Hon. A.J. (Manch'r'" do      
    before do    
      @rt_hon_aj_balfour_manchester = VoteName.new("Balfour, Rt. Hon. A.J. (Manch'r")
    end
  
    it "should return a forename of 'A.J.'" do
      @rt_hon_aj_balfour_manchester.forename.should == "A.J."
    end
  
    it "should return a surname of 'Balfour'" do
      @rt_hon_aj_balfour_manchester.surname.should == "Balfour"  
    end
    
    it "should not return a title" do
      @rt_hon_aj_balfour_manchester.title.should == ""
    end
    
    it "should return a constituency of 'Manchester'" do
      @rt_hon_aj_balfour_manchester.constituency.should == "Manchester"  
    end  
  end
  
  describe "given VoteName 'Balfour, Gerald William (Leeds)'" do
    before do    
      @gerald_william_balfour_leeds = VoteName.new("Balfour, Gerald William (Leeds)")
    end
  
    it "should return a forename of 'Gerald William'" do
      @gerald_william_balfour_leeds.forename.should == "Gerald William"
    end
  
    it "should return a surname of 'Balfour'" do
      @gerald_william_balfour_leeds.surname.should == "Balfour"  
    end
    
    it "should not return a title" do
      @gerald_william_balfour_leeds.title.should == ""
    end
    
    it "should return a constituency of 'Leeds'" do
      @gerald_william_balfour_leeds.constituency.should == "Leeds"  
    end  
  end
  
  describe "given VoteName 'Barry, A. H. Smith-'" do
    before do    
      @barry_a_h_smith = VoteName.new("Barry, A. H. Smith-")
    end
  
    it "should return a forename of 'A. H.'" do
      @barry_a_h_smith.forename.should == "A. H."
    end
  
    it "should return a surname of 'Smith-Barry'" do
      @barry_a_h_smith.surname.should == "Smith-Barry"
    end
    
    it "should not return a title" do
      @barry_a_h_smith.title.should == ""
    end
    
    it "should not return a constituency" do
      @barry_a_h_smith.constituency.should == ""  
    end  
  end
  
  describe "given VoteName 'Wilson-Todd, Wm. H. (Yorks.'" do
    before do    
      @wilson_todd_wm_h_yorks = VoteName.new("Balfour, Gerald William (Leeds)")
    end
  
    it "should return a forename of 'William H.'" do
      @wilson_todd_wm_h_yorks.forename.should == "William H."
    end
  
    it "should return a surname of 'Wilson-Todd'" do
      @wilson_todd_wm_h_yorks.surname.should == "Wilson-Todd"  
    end
    
    it "should not return a title" do
      @wilson_todd_wm_h_yorks.title.should == ""
    end
    
    it "should return a constituency of 'Yorkshire'" do
      @wilson_todd_wm_h_yorks.constituency.should == "Yorkshire"  
    end  
  end
end
