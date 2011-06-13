require File.join(File.expand_path(File.dirname(__FILE__)), '../spec_helper')

require 'rack/test'

class SinatraMMGeoipApp < Sinatra::Base
  use Rack::MMGeoip
  helpers Sinatra::MMGeoip
  
  get '/' do
    geoip.city
  end
  
end

describe Sinatra::MMGeoip do
  include Rack::Test::Methods
  
  def app
    SinatraMMGeoipApp
  end
  
  describe "a test app which just puts the city into the body" do
    describe "with a remote address in the env hash" do
      it "returns the city as response" do
        get '/', {}, {'REMOTE_ADDR' => '134.34.3.2'}
        puts last_response.body
        last_response.should be_ok
        last_response.body.should == 'Konstanz'
      end
    end
    describe "without a remote address in the env hash" do
      it "returns an emty response" do
        get '/'
        last_response.should be_ok
        last_response.body.should == ''
      end
    end
  end
end