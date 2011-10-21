require 'rake'
require 'rake/testtask'
require 'rubygems/package_task'
require 'rdoc/task'

GEM_NAME = 'sms_sender'

# Read the spec file
spec = Gem::Specification.load("#{GEM_NAME}.gemspec")

# Setup generic gem
desc 'Turn this plugin into a gem.'
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

# Rdoc
desc 'Generate documentation for the %s plugin.' % GEM_NAME
Rdoc::Task.new('rdoc') do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SmsSender'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Test
desc 'Default: run unit tests.'
task :default => :test

desc 'Test the %s plugin.' % GEM_NAME
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
