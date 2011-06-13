require 'mm_geoip.rb'

module Rack
  class MMGeoip
    def initialize(app)
      @app = app
    end
    
    def call(env)
      @app.call env.dup.merge('GEOIP' => ::MMGeoip.new(env))
    end
  end
end

