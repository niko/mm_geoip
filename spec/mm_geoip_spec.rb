require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe MMGeoip do
  describe "the whole stack" do
    before(:each) do
      @env = {:ip => '134.34.3.2'}
    end
    it "should be fast" do
      # Succeeds with a margin of about 10% on my MBP core2duo 2.4GHz.
      # On slower computers this will fail.
      with_lookup = Benchmark.measure{
        1000.times{mm_geoip = MMGeoip.new @env ; mm_geoip.city} # with lookup
      }.total.should < 0.5
    end
    it "be lazy" do
      with_lookup = Benchmark.measure{
        1000.times{mm_geoip = MMGeoip.new @env ; mm_geoip.city} # with lookup
      }.total
      
      no_lookup = Benchmark.measure{
        1000.times{mm_geoip = MMGeoip.new @env} # no lookup
      }.total
      
      (no_lookup*3).should < with_lookup
    end
  end
  
  describe "#initialize" do
    it "works with the IP as :ip field" do
      MMGeoip.new :ip => '134.34.3.2'
    end
    it "works with the IP as 'REMOTE_ADDR' field" do
      MMGeoip.new 'REMOTE_ADDR' => '134.34.3.2'
    end
    it "raises, if not :ip or 'REMOTE_ADDR' is given" do
      lambda{ MMGeoip.new :whatelse => 'something' }.should raise_error(MMGeoip::NoIpGiven)
    end
    it "puts the parameter into the env instance variable" do
      env = {:ip => '134.34.3.2'}
      mm_geoip = MMGeoip.new(env)
      mm_geoip.instance_variable_get('@env').should == env
    end
    it "sets up a geipdb object" do
      mm_geoip = MMGeoip.new(:ip => '134.34.3.2')
      mm_geoip.instance_variable_get('@geodb').should be_a(GeoIP)
    end
  end
  
  describe "the getters" do
    it "works" do
      mm_geoip = MMGeoip.new :ip => '134.34.3.2'
      mm_geoip.ip.should == '134.34.3.2'
      
      mm_geoip.hostname.should          == '134.34.3.2'
      mm_geoip.ip.should                == '134.34.3.2'
      mm_geoip.country_code.should      == 'DE'
      mm_geoip.country_code3.should     == 'DEU'
      mm_geoip.country_name.should      == 'Germany'
      mm_geoip.country_continent.should == 'EU'
      mm_geoip.region.should            == '01'
      mm_geoip.city.should              == 'Konstanz'
      mm_geoip.postal_code.should       == ''
      mm_geoip.lat.should               == 47.66669999999999
      mm_geoip.lng.should               == 9.183300000000003
      mm_geoip.dma_code.should          == nil
      mm_geoip.area_code.should         == nil
      mm_geoip.timezone.should          == 'Europe/Berlin'
      mm_geoip.region_name.should       == 'Baden-Wurttemberg'
    end
  end
  
  describe "#get_from_env" do
    it "tries the env fields" do
      MMGeoip.new(:ip => '134.34.3.2', :hostname => 'hostname').hostname.should == 'hostname'
      MMGeoip.new(:ip => '134.34.3.2', 'GEOIP_HOSTNAME' => 'geoip hostname').hostname.should == 'geoip hostname'
      MMGeoip.new(:ip => '134.34.3.2', 'X_GEOIP_HOSTNAME' => 'x geoip hostname').hostname.should == 'x geoip hostname'
    end
  end
end