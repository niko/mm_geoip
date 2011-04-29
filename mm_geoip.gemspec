$:.unshift File.expand_path('../lib', __FILE__)
require 'mm_geoip/version'

Gem::Specification.new do |s|
  s.name         = "mm_geoip"
  s.version      = MMGeoip::VERSION
  s.authors      = ["Niko Dittmann"]
  s.email        = "mail+git@niko-dittmann.com"
  s.homepage     = "http://github.com/niko/mm_geoip"
  s.summary      = "A proxy object around the geoip gem for lazy lookup. Includes a Rack middleware."
  s.description  = "A proxy object around the geoip gem for lazy lookup. Includes a Rack middleware."
  
  s.files        = Dir.glob('lib/**/*') + Dir.glob('data/*')
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  
  s.add_runtime_dependency "geoip"
end
