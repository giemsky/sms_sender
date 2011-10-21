# encoding: utf-8

Gem::Specification.new do |spec|
  spec.name = 'sms_sender'
  spec.version = '0.0.4'
  spec.homepage = 'https://github.com/mzubala/sms_sender'
  spec.summary = 'Sends sms messages using http://smsapi.pl'
  spec.authors = ['Maciej Zubala - RocketMind Software', 'Tomasz Pajor']
  spec.platform = Gem::Platform::RUBY
  spec.files = Dir.glob(['MIT_LICENSE',
                         'README',
                         'Rakefile',
                         'sms_sender.gemspec',
                         'init.rb',
                         'lib/**/*.rb',
                         'test/**/*'])
  spec.test_files = Dir.glob('test/**/*_test.rb')
  spec.required_ruby_version = '>= 1.8.6'
  spec.require_path = 'lib'
  spec.has_rdoc = false
  spec.extra_rdoc_files = ['README']
  spec.date = DateTime.now
end
