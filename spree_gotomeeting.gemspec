# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_gotomeeting'
  s.version     = '0.11'
  s.summary     = 'Spree Gotomeeting Product'
  s.description = 'Spree extension that adds the ability to create webinars as products, which interface with the Citrix Gotomeeting API'
  s.required_ruby_version = '>= 2.1.0'

  s.author    = 'Thomas Saunders'
  s.email     = 'saun0063@umn.edu'
  s.homepage  = 'http://eti.umn.edu'
  s.license = 'BSD-3'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.1.0.rc3'
  s.add_dependency 'go_to_webinar', '~> 0.0.3'
  s.add_dependency 'validates_timeliness', '~> 4.0'

  s.add_development_dependency 'capybara', '~> 2.6'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails', '~> 3.4'
  s.add_development_dependency 'sass-rails', '~> 5.0.0'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
