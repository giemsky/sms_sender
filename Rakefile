require 'rake'
require "bundler/gem_tasks"
require 'rake/testtask'
require 'rdoc/task'

GEM_NAME = 'sms_sender'

# Read the spec file
spec = Gem::Specification.load("#{GEM_NAME}.gemspec")

## Rdoc
#desc 'Generate documentation for the %s plugin.' % GEM_NAME
#Rdoc::Task.new('rdoc') do |rdoc|
#  rdoc.rdoc_dir = 'rdoc'
#  rdoc.title    = 'SmsSender'
#  rdoc.options << '--line-numbers' << '--inline-source'
#  rdoc.rdoc_files.include('README')
#  rdoc.rdoc_files.include('lib/**/*.rb')
#end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec