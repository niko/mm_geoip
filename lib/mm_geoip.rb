require 'geoip'

$LOAD_PATH << File.dirname(File.expand_path __FILE__)

require 'mm_geoip/region'

class MMGeoip
  DATA_PATH = File.join(File.dirname(File.expand_path(__FILE__)), '../data')
  
  FIELDS = [:hostname, :ip, :country_code, :country_code3, :country_name,
    :country_continent, :region, :city, :postal_code, :lat, :lng, :dma_code,
    :area_code, :timezone]
  attr_reader :fields
  
  class NoIpGiven < StandardError; end
  
  def initialize(env)
    @env = env # may be a Rack @env or any hash containing initial data
    @env[:ip] ||= @env["REMOTE_ADDR"] # :ip or "REMOTE_ADDR" should be present
    
    raise NoIpGiven.new unless @env[:ip]
    
    @geodb = GeoIP.new File.join(DATA_PATH, 'GeoLiteCity.dat')
  end
  
  FIELDS.each do |getter|
    define_method getter do
      looked_up? ? fields[getter] || get_from_env(getter) : get_from_env(getter) || fields[getter]
    end
  end
  
  def get_from_env(field)
    @env[field] || @env["GEOIP_#{field.upcase}"] || @env["X_GEOIP_#{field.upcase}"]
  end
  
  def region_name
    Regions[country_code.to_sym] && Regions[country_code.to_sym][region]
  end
  
  def looked_up?
    !!@fields
  end
  
  def fields
    return @fields if @fields
    
    @fields = Hash[FIELDS.zip @geodb.city(@env[:ip])]
    @fields[:region_name] = region_name
    @fields
  end
  
end


env = {'REMOTE_ADDR' => '217.24.207.26'}
m = MMGeoip.new env
p m.fields


env = {'REMOTE_ADDR' => '91.23.138.121'}
m = MMGeoip.new env
p m.fields


env = {'REMOTE_ADDR' => '128.176.6.250'}
m = MMGeoip.new env
p m.fields

