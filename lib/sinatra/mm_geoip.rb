require 'rack/mm_geoip.rb'

module Sinatra
  module MMGeoip
    
    # Just a convinience method to access the mm_geoip proxy
    # object in Sinatra routes and views.
    def geoip
      request.env['GEOIP']
    end
    
  end
  
  helpers MMGeoip
end
