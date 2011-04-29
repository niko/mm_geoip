module Rack
  class MMGeoip
    def initialize(app)
      @app = app
    end
    
    def call(env)
      env['GEOIP'] = ::MMGeoip.new env
      @app.call(env)
    end
  end
end
