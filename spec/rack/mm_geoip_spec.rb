require File.join(File.expand_path(File.dirname(__FILE__)), '../spec_helper')

describe Rack::MMGeoip do
  describe '#call' do
    it "adds a MMGeoip object to the env hash" do
      app = proc{|env| env}
      rack_geoip = Rack::MMGeoip.new app
      rack_geoip.call({:ip => '134.34.3.2'})['GEOIP'].should be_a(MMGeoip)
    end
  end
end