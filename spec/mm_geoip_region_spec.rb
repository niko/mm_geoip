require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe MMGeoip::Regions do
  describe "#parse" do
    it "works" do
      MMGeoip::Regions.parse[:CA]['NS'].should == 'Nova Scotia'       # CA,NS,"Nova Scotia"
      MMGeoip::Regions.parse[:US]['AL'].should == 'Alabama'           # US,AL,"Alabama"
      MMGeoip::Regions.parse[:DE]['01'].should == 'Baden-Wurttemberg' # DE,02,"Bayern"
      MMGeoip::Regions.parse[:DE]['02'].should == 'Bayern'            # DE,01,"Baden-Wurttemberg"
    end
  end
  describe "#[]" do
    it "works" do
      MMGeoip::Regions[:CA]['NS'].should == 'Nova Scotia'       # CA,NS,"Nova Scotia"
      MMGeoip::Regions[:US]['AL'].should == 'Alabama'           # US,AL,"Alabama"
      MMGeoip::Regions[:DE]['01'].should == 'Baden-Wurttemberg' # DE,02,"Bayern"
      MMGeoip::Regions[:DE]['02'].should == 'Bayern'            # DE,01,"Baden-Wurttemberg"
    end
  end
end