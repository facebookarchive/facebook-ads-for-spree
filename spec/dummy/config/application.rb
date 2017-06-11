# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups(assets: %w(development test)))


begin
  require 'spree_frontend'
rescue LoadError
  # spree_frontend is not available.
end
      
begin
  require 'spree_backend'
rescue LoadError
  # spree_backend is not available.
end
      
begin
  require 'spree_api'
rescue LoadError
  # spree_api is not available.
end
      require 'facebook_ads_for_spree'

module Dummy
  class Application < Rails::Application
    
    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end


