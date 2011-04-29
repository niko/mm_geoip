require 'rubygems'
require 'rspec/core/rake_task'

desc "Run spec with specdoc output"
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = '--color --format documentation'
end

def download_file(url_string, opts)
  require 'net/http'
  require 'uri'
  
  url = URI.parse url_string
  puts "Downloading #{url_string} to #{opts[:to]}..."
  
  File.open(opts[:to], 'w') do |file|
    Net::HTTP.start url.host do |http|
      http.request_get url.path do |resp|
        i=0
        resp.read_body do |segment|
          print '.' if (i+=1)%100 == 1
          file.write(segment)
        end
      end
    end
  end
  
  puts 'done.'
  puts "Downloaded #{url_string} to #{opts[:to]}: #{File.size(opts[:to])/1024**2} MB"
end

desc "Update included IP database from Maxmind.com"
task :update do |t|
  src = 'http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz'
  dest = File.join(File.dirname(File.expand_path(__FILE__)), 'data/GeoLiteCity.dat.gz')
  download_file src, :to => dest
  `gunzip #{dest}`
end