class Regions
  class << self
    
    def [](country_key)
      @regions_hash ||= parse
      @regions_hash[country_key.to_sym]
    end
    
    def parse
      regions_hash = {}
      File.open(File.join(MMGeoip::DATA_PATH, 'fips_and_3166_2.txt')).each_line do |line|
        line_parts = line.split(',')
        country, area, area_name = line_parts[0].to_sym, line_parts[1], line_parts[2].gsub('"','').strip
        
        regions_hash[country] ||= {}
        regions_hash[country][area] = area_name
      end
      regions_hash
    end
    
  end
end
