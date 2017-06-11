# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'facebook_ads_for_spree/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'facebook_ads_for_spree'
  s.version     = FacebookAdsForSpree.version
  s.summary     = 'Spree extension for advertising products on Facebook'
  s.description = 'FacebookAdsForSpree makes it easy to advertise your products on Facebook. It exports your Spree products to "Facebook Product Catalogs" and installs "Facebook Pixel" in your Spree shop.'
  s.required_ruby_version = '>= 2.2.2'

  s.author    = 'Facebook Inc.'
  s.email     = 'info@facebook.com'
  s.homepage  = 'https://github.com/facebookincubator/facebook-ads-for-spree'
  s.license = 'https://developers.facebook.com/policy/'

  # s.files       = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 3.1.0', '< 4.0'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'appraisal'
end
