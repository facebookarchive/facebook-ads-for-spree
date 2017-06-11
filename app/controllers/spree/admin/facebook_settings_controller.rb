# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.
module Spree
  module Admin

    # FacebookSettingsController renders a page with 'Connect to Facebook' button and stores facebook settings to 'settings' table
    # SettingsController cannot be used because it allows unauthorized access
    class FacebookSettingsController < Spree::Admin::BaseController
      require 'facebook/ads/settings.rb'
      include Facebook::Ads::SettingsUpdater

      # TODO find a better way of using url helpers
      include Rails.application.routes.url_helpers

      def index
      end
    end
  end
end
