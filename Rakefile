require 'rubygems'
require 'rspec/core/rake_task'

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.rspec_opts = '--color --format documentation'
end

task :default => :spec
