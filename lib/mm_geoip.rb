require 'geoip'

$LOAD_PATH << File.dirname(File.expand_path __FILE__)

class MMGeoip; end

require 'mm_geoip/region'

class MMGeoip
  FIELDS = [:hostname, :ip, :country_code, :country_code3, :country_name,
    :country_continent, :region, :city, :postal_code, :lat, :lng, :dma_code,
    :area_code, :timezone]
  attr_reader :lookup
  
  class NoIpGiven < StandardError; end
  
  def initialize(env)
    @env = env # may be a Rack @env or any hash containing initial data
    @env[:ip] ||= @env["REMOTE_ADDR"] # :ip or "REMOTE_ADDR" should be present
    
    raise NoIpGiven.new unless @env[:ip]
    
    @geodb = GeoIP.new self.class.db_path
  end
  
  FIELDS.each do |field|
    define_method field do
      # if already looked up, get field from lookup or environment (lookup has priority)
      # else                  get field from environment or lookup (environment has priority; perhaps we don't have to lookup)
      # looked_up? ? fields[field] || get_from_env(field) : get_from_env(field) || fields[field]
      looked_up? ? lookup[field]  || get_from_env(field)  : get_from_env(field) || lookup[field]
    end
  end
  
  def get_from_env(field)
    # APACHE:GEOIP with Geolite City give us:
    # GEOIP_REGION, GEOIP_CITY, GEOIP_DMA_CODE, GEOIP_AREA_CODE, GEOIP_LAT, GEOIP_LNG
    # 
    # Nginx with HttpGeoIPModule and Geolite City makes these variables available in nginx.conf:
    # $geoip_country_code, ..., you'll have to set the env variables by yourself.
    # I'd recommend using the X_GEOIP_... form.
    # 
    # Here, we look for both forms and the plain version.
    # 
    @env[field] || @env["GEOIP_#{field.to_s.upcase}"] || @env["X_GEOIP_#{field.to_s.upcase}"]
  end
  
  def region_name
    country_code && MMGeoip::Regions[country_code.to_sym] && MMGeoip::Regions[country_code.to_sym][region]
  end
  
  def looked_up?
    !!@lookup
  end
  
  def lookup
    return @lookup if @lookup
    
    looked_up_fields = @geodb.city @env[:ip]
    
    return @lookup = {} unless looked_up_fields
    
    @lookup = Hash[FIELDS.zip looked_up_fields]
    @lookup[:region_name] = region_name
    @lookup
  end
  
  def self.data_path
    File.join(File.dirname(File.expand_path(__FILE__)), '../data')
  end
  def self.db_path
    @db_path || File.join(data_path, 'GeoLiteCity.dat')
  end
  def self.db_path=(path)
    @db_path = path
  end
  
end
