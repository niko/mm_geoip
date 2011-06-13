$LOAD_PATH << File.join(File.dirname(File.expand_path __FILE__), '../lib')

require 'benchmark'

require 'mm_geoip'
require 'rack/mm_geoip'
require 'sinatra/base'
require 'sinatra/mm_geoip'

