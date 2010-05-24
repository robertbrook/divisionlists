require 'vote_name'

describe "The VoteName Parser" do
  describe "given VoteName 'Aird, John'" do
    before do    
      @john_aird = VoteName.new("Aird, John")
    end
  
    it "should return a forename of 'John'" do
      @john_aird.forename.should == "John"  
    end
    
    it 'should not return a parliamentary_title' do
      @john_aird.parliamentary_title.should == ''
    end
    
    it 'should not return a title' do
      @john_aird.title.should == ''
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
    
    it "should not return a parliamentary_title" do
      @sir_william_arrol.parliamentary_title.should == ""
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
    
    it "should return a parliamentary_title of 'Rt. Hon.'" do
      @rt_hon_john_atkinson.parliamentary_title.should == "Rt. Hon."
    end
  end
  
  describe "given VoteName 'Balfour, Rt. Hon. A.J. (Manch'r'" do      
    before do    
      @rt_hon_aj_balfour_manchester = VoteName.new("Balfour, Rt. Hon. A.J. (Manch'r")
    end
  
    it "should return a forename of 'A. J.'" do
      @rt_hon_aj_balfour_manchester.forename.should == "A. J."
    end
  
    it "should return a surname of 'Balfour'" do
      @rt_hon_aj_balfour_manchester.surname.should == "Balfour"  
    end
    
    it "should not return a title" do
      @rt_hon_aj_balfour_manchester.title.should == ""
    end
    
    it "should return a parliamentary_title = 'Rt. Hon." do
      @rt_hon_aj_balfour_manchester.parliamentary_title.should == "Rt. Hon."
    end
    
    it "should return a constituency of 'Manchester'" do
      @rt_hon_aj_balfour_manchester.constituency.should == "Manchester"  
    end  
  end
  
  describe "given VoteName 'Balfour ,Gerald William (Leeds)'" do
    before do    
      @gerald_william_balfour_leeds = VoteName.new("Balfour ,Gerald William (Leeds)")
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
    
    it "should not return a parliamentary_title" do
      @gerald_william_balfour_leeds.parliamentary_title.should == ""
    end
    
    it "should return a constituency of 'Leeds'" do
      @gerald_william_balfour_leeds.constituency.should == "Leeds"  
    end  
  end
  
  describe "given VoteName '(Balfour ,Gerald William (Leeds)'" do
    before do    
      @gerald_william_balfour_leeds = VoteName.new("(Balfour ,Gerald William (Leeds)")
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
    
    it "should not return a parliamentary_title" do
      @gerald_william_balfour_leeds.parliamentary_title.should == ""
    end
    
    it "should return a constituency of 'Leeds'" do
      @gerald_william_balfour_leeds.constituency.should == "Leeds"  
    end  
  end
  
  describe "given VoteName '(Balfour ,Gerald William'" do
    before do    
      @gerald_william_balfour = VoteName.new("(Balfour ,Gerald William")
    end
  
    it "should return a forename of 'Gerald William'" do
      @gerald_william_balfour.forename.should == "Gerald William"
    end
  
    it "should return a surname of 'Balfour'" do
      @gerald_william_balfour.surname.should == "Balfour"  
    end
    
    it "should not return a title" do
      @gerald_william_balfour.title.should == ""
    end
    
    it "should not return a parliamentary_title" do
      @gerald_william_balfour.parliamentary_title.should == ""
    end
    
    it "should not return a constituency" do
      @gerald_william_balfour.constituency.should == ""
    end  
  end
  
  describe "given VoteName 'Barry, A. H. Smith- (Hunts.)'" do
    before do    
      @barry_a_h_smith = VoteName.new("Barry, A. H. Smith- (Hunts.)")
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
    
    it "should not return a parliamentary_title" do
      @barry_a_h_smith.parliamentary_title.should == ""
    end
    
    it "should return a constituency of 'Huntingdon'" do
      @barry_a_h_smith.constituency.should == "Huntingdon"
    end  
  end
  
  describe "given VoteName 'Beach,Rt.Hn.SirM.H.(Bristol)'" do
    before do    
      @beach_rt_hn_sir_m_h = VoteName.new("Beach,Rt.Hn.SirM.H.(Bristol)")
    end
  
    it "should return a forename of 'M. H.'" do
      @beach_rt_hn_sir_m_h.forename.should == "M. H."
    end
  
    it "should return a surname of 'Beach'" do
      @beach_rt_hn_sir_m_h.surname.should == "Beach"
    end
    
    it "should return a parliamentary_title of 'Rt. Hon." do
      @beach_rt_hn_sir_m_h.parliamentary_title.should == "Rt. Hon."
    end
    
    it "should return a title of 'Sir'" do
      @beach_rt_hn_sir_m_h.title.should == "Sir"
    end
    
    it "should return a constituency of 'Bristol'" do
      @beach_rt_hn_sir_m_h.constituency.should == "Bristol"
    end  
  end
  
  describe "given VoteName 'Wilson-Todd, Wm. H. (Yorks.'" do
    before do    
      @wilson_todd_wm_h_yorks = VoteName.new("Wilson-Todd, Wm. H. (Yorks.")
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
    
    it "should not return a parliamentary_title" do
      @wilson_todd_wm_h_yorks.parliamentary_title.should == ""
    end
    
    it "should return a constituency of 'Yorkshire'" do
      @wilson_todd_wm_h_yorks.constituency.should == "Yorkshire"
    end  
  end
  
  describe "given VoteName 'Laurie, Lieut.-General'" do
    before do    
      @laurie_lieut_general = VoteName.new("Laurie, Lieut.-General")
    end
  
    it "should not return a forename" do
      @laurie_lieut_general.forename.should == ""
    end
  
    it "should return a surname of 'Laurie'" do
      @laurie_lieut_general.surname.should == "Laurie"
    end
    
    it "should return a title of 'Lieut.-General'" do
      @laurie_lieut_general.title.should == "Lieutenant General"
    end
    
    it "should not return a parliamentary_title" do
      @laurie_lieut_general.parliamentary_title.should == ""
    end
    
    it "should not return a constituency" do
      @laurie_lieut_general.constituency.should == ""
    end  
  end
  
  describe "given VoteName 'Welby, Lieut.-Col. A. C. E.'" do
    before do    
      @welby_lieut_col_a_c_e = VoteName.new("Welby, Lieut.-Col. A. C. E.")
    end
  
    it "should return a forename of 'A. C. E." do
      @welby_lieut_col_a_c_e.forename.should == "A. C. E."
    end
  
    it "should return a surname of 'Welby'" do
      @welby_lieut_col_a_c_e.surname.should == "Welby"
    end
    
    it "should return a title of 'Lieut.-Col.'" do
      @welby_lieut_col_a_c_e.title.should == "Lieutenant Colonel"
    end
    
    it "should not return a parliamentary_title" do
      @welby_lieut_col_a_c_e.parliamentary_title.should == ""
    end
    
    it "should not return a constituency" do
      @welby_lieut_col_a_c_e.constituency.should == ""
    end  
  end
  
  describe "given VoteName 'Williams, Joseph Powell-(Birm.)'" do
    before do    
      @williams_joseph_powell_birm = VoteName.new("Williams, Joseph Powell-(Birm.)")
    end
  
    it "should return a forename of 'Joseph" do
      @williams_joseph_powell_birm.forename.should == "Joseph"
    end
  
    it "should return a surname of 'Powell-Williams'" do
      @williams_joseph_powell_birm.surname.should == "Powell-Williams"
    end
    
    it "should not return a title" do
      @williams_joseph_powell_birm.title.should == ""
    end
    
    it "should not return a parliamentary_title" do
      @williams_joseph_powell_birm.parliamentary_title.should == ""
    end
    
    it "should return a constituency of 'Birmingham'" do
      @williams_joseph_powell_birm.constituency.should == "Birmingham"
    end  
  end
  
  describe "given VoteName 'Bathurst, Hon. Allen Benjamin'" do
    before do    
      @bathurst_hon_allen_benjamin = VoteName.new("Bathurst, Hon. Allen Benjamin")
    end
  
    it "should return a forename of 'Allen Benjamin" do
      @bathurst_hon_allen_benjamin.forename.should == "Allen Benjamin"
    end
  
    it "should return a surname of 'Bathurst'" do
      @bathurst_hon_allen_benjamin.surname.should == "Bathurst"
    end
    
    it "should not return a title" do
      @bathurst_hon_allen_benjamin.title.should == ""
    end
    
    it "should return a parliamentary_title of 'Hon.'" do
      @bathurst_hon_allen_benjamin.parliamentary_title.should == "Hon."
    end
    
    it "should not return a constituency" do
      @bathurst_hon_allen_benjamin.constituency.should == ""
    end  
  end
  
  describe "given VoteName 'Kinloch,SirJohnGeorgeSmyth'" do
    before do    
      @kinloch_sir_john_geoge_smyth = VoteName.new("Kinloch,SirJohnGeorgeSmyth")
    end
  
    it "should return a forename of 'John George Smyth" do
      @kinloch_sir_john_geoge_smyth.forename.should == "John George Smyth"
    end
  
    it "should return a surname of 'Kinloch'" do
      @kinloch_sir_john_geoge_smyth.surname.should == "Kinloch"
    end
    
    it "should return a title of 'Sir'" do
      @kinloch_sir_john_geoge_smyth.title.should == "Sir"
    end
    
    it "should not return a parliamentary_title" do
      @kinloch_sir_john_geoge_smyth.parliamentary_title.should == ""
    end
    
    it "should not return a constituency" do
      @kinloch_sir_john_geoge_smyth.constituency.should == ""
    end  
  end
  
  describe "given VoteName 'Balfour,Rt Hn.J.Blair'" do
    before do    
      @balfour_rt_hn_j_blair = VoteName.new("Balfour,Rt Hn.J.Blair")
    end
  
    it "should return a forename of 'J. Blair'" do
      @balfour_rt_hn_j_blair.forename.should == "J. Blair"
    end
  
    it "should return a surname of 'Balfour'" do
      @balfour_rt_hn_j_blair.surname.should == "Balfour"
    end
    
    it "should not return a title" do
      @balfour_rt_hn_j_blair.title.should == ""
    end
    
    it "should return a parliamentary_title of 'Rt. Hon." do
      @balfour_rt_hn_j_blair.parliamentary_title.should == "Rt. Hon."
    end
    
    it "should not return a constituency" do
      @balfour_rt_hn_j_blair.constituency.should == ""
    end  
  end
  
  describe "given VoteName 'Wyvill, Marmaduke D'Arcy'" do
    before do    
      @wyvill_marmaduke_darcy = VoteName.new("Wyvill, Marmaduke D'Arcy")
    end
  
    it "should return a forename of 'Marmaduke D'Arcy'" do
      @wyvill_marmaduke_darcy.forename.should == "Marmaduke D'Arcy"
    end
  
    it "should return a surname of 'Wyvill'" do
      @wyvill_marmaduke_darcy.surname.should == "Wyvill"
    end
    
    it "should not return a title" do
      @wyvill_marmaduke_darcy.title.should == ""
    end
    
    it "should not return a parliamentary_title" do
      @wyvill_marmaduke_darcy.parliamentary_title.should == ""
    end
    
    it "should not return a constituency" do
      @wyvill_marmaduke_darcy.constituency.should == ""
    end
  end
  
  describe "given VoteName 'Williams,JosephPowell-(Bi???'" do
    before do    
      @williams_joseph_powell = VoteName.new("Williams,JosephPowell-(Bi???")
    end
  
    it "should return a forename of 'Joseph'" do
      @williams_joseph_powell.forename.should == "Joseph"
    end
  
    it "should return a surname of 'Powell-Williams'" do
      @williams_joseph_powell.surname.should == "Powell-Williams"
    end
    
    it "should not return a title" do
      @williams_joseph_powell.title.should == ""
    end
    
    it "should not return a parliamentary_title" do
      @williams_joseph_powell.parliamentary_title.should == ""
    end
    
    it "should return a constituency of 'Bi???" do
      @williams_joseph_powell.constituency.should == "Bi???"
    end
  end
  
  describe "given VoteName 'MacAleese, Daniel'" do
    before do    
      @macaleese_daniel = VoteName.new("MacAleese, Daniel")
    end
  
    it "should return a forename of 'Daniel'" do
      @macaleese_daniel.forename.should == "Daniel"
    end
  
    it "should return a surname of 'MacAleese'" do
      @macaleese_daniel.surname.should == "MacAleese"
    end
  end
  
  describe "give VoteName 'Smith, Dave (Isle of W)" do
    it "should return the constituency 'Isle of Wight'" do
      dave_smith = VoteName.new("Smith, Dave (Isle of W)")
      dave_smith.constituency.should == "Isle of Wight"
    end
  end
  
  describe "give VoteName 'Smith, Dave (Isle of W???)" do
    it "should return the constituency 'Isle of Wight'" do
      dave_smith = VoteName.new("Smith, Dave (Isle of W???)")
      dave_smith.constituency.should == "Isle of Wight"
    end
  end
  
  describe "give VoteName 'Smith, Dave (Isle ofWight)'" do
    it "should return the constituency 'Isle of Wight'" do
      dave_smith = VoteName.new("Smith, Dave (Isle ofWight)")
      dave_smith.constituency.should == "Isle of Wight"
    end
  end

  describe "give VoteName 'Smith, Dave (King's L'nn)" do
    it "should return the constituency 'King\'s Lynn'" do
      dave_smith = VoteName.new("Smith, Dave (King's L'nn)")
      dave_smith.constituency.should == "King's Lynn"
    end
  end
  
  describe "give VoteName 'Smith, Dave (Stockton-on-T???)" do
    it "should return the constituency 'Stockton-on-Tees'" do
      dave_smith = VoteName.new("Smith, Dave (Stockton-on-T???)")
      dave_smith.constituency.should == "Stockton-on-Tees"
    end
  end
  
  describe "give VoteName 'Smith, Dave (Stockton-on-Tee)" do
    it "should return the constituency 'Stockton-on-Tees'" do
      dave_smith = VoteName.new("Smith, Dave (Stockton-on-Tee)")
      dave_smith.constituency.should == "Stockton-on-Tees"
    end
  end
  
  describe "give VoteName 'Smith, Dave (Swn's'a)" do
    it "should return the constituency 'Swansea'" do
      dave_smith = VoteName.new("Smith, Dave (Swn's'a)")
      dave_smith.constituency.should == "Swansea"
    end
  end
  
  describe "give VoteName 'Smith, Dave (Heref'd)" do
    it "should return the constituency 'Hereford'" do
      dave_smith = VoteName.new("Smith, Dave (Heref'd)")
      dave_smith.constituency.should == "Hereford"
    end
  end
  
  describe "give a VoteName with q constituency ending 'sh." do
    it "should return a constituency ending with 'shire'" do
      dave_smith = VoteName.new("Smith, Dave (Berksh.)")
      dave_smith.constituency.should == "Berkshire"
      
      dave_smith = VoteName.new("Smith, Dave (Caithness-sh.)")
      dave_smith.constituency.should == "Caithness-shire"
      
      dave_smith = VoteName.new("Smith, Dave (Derbysh.)")
      dave_smith.constituency.should == "Derbyshire"
    end
  end
  
  describe "give VoteName 'Smith, Dave (Beds.)" do
    it "should return the constituency 'Bedfordshire'" do
      dave_smith = VoteName.new("Smith, Dave (Beds.)")
      dave_smith.constituency.should == "Bedfordshire"
    end
  end
  
  describe "give VoteName 'Smith, Dave (Antrim,E.)" do
    it "should return the constituency 'Antrim East'" do
      dave_smith = VoteName.new("Smith, Dave (Antrim,E.)")
      dave_smith.constituency.should == "Antrim East"
    end
  end
  
  describe "give VoteName 'Smith, Dave (Antrim N.)" do
    it "should return the constituency 'Antrim North'" do
      dave_smith = VoteName.new("Smith, Dave (Antrim N.)")
      dave_smith.constituency.should == "Antrim North"
    end
  end
  
  describe "give VoteName 'Smith, Dave (Newc.under Lyme)" do
    it "should return the constituency 'Newcastle under Lyme'" do
      dave_smith = VoteName.new("Smith, Dave (Newc.under Lyme)")
      dave_smith.constituency.should == "Newcastle under Lyme"
    end
  end
  
  describe "give VoteName 'Smith, Dave (Breconsh???)" do
    it "should return the constituency 'Breconshire'" do
      dave_smith = VoteName.new("Smith, Dave (Breconsh???)")
      dave_smith.constituency.should == "Breconshire"
    end
  end
end