class MMGeoip::Regions
  class << self
    
    # Memoization and convinience for #parse.
    def [](country_key)
      @regions_hash ||= parse
      @regions_hash[country_key.to_sym]
    end
    
    # Parse the included regions file.
    # It contains both, the ISO 3166-2 Subcountry codes for Canada and the US
    # and the FIPS 10-4 Subcountry codes for the rest of the world.
    # http://www.maxmind.com/app/iso3166_2
    # http://www.maxmind.com/app/fips10_4)
    # 
    def parse
      regions_hash = {}
      File.open(File.join(MMGeoip::data_path, 'fips_and_3166_2.txt')).each_line do |line|
        line_parts = line.split(',')
        country, area, area_name = line_parts[0].to_sym, line_parts[1], line_parts[2].gsub('"','').strip
        
        regions_hash[country] ||= {}
        regions_hash[country][area] = area_name
      end
      regions_hash
    end
    
  end
end
