# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

# Make Spree::Product act_as_facebook_product_item
# User can redefine behavior by overriding fb_FIELD_NAME, where FIELD_NAME is any field name supported by
# Facebook Product Catalogs (https://developers.facebook.com/docs/marketing-api/dynamic-product-ads/product-catalog)
module Spree
  Product.class_eval do
    include Facebook::Ads::ActsAsFacebookProductItem

    acts_as_facebook_product_item Facebook::Ads::PRODUCT_ITEM_FIELDS.map{|field| [field, "fb_#{field}".to_sym]}.to_h

    def fb_id
      id
    end

    def fb_description
      description
    end

    def fb_price
      price
    end

    def fb_availability
      available? ? "in stock" : "out of stock"
    end

    def fb_condition
      "new"
    end

    # User should set asset_url to a valid images host. E.g.:
    #   config.action_controller.asset_host = "http://your.image.serving.host"
    def fb_image_link
      image_path = master_images.first.try(:attachment).try(:url, :large)
      image_path.blank? ? nil : ActionController::Base.helpers.asset_path(image_path)
    end

    # User should set default_url_options to point to his production web server:
    #   config.action_controller.default_url_options = { host: 'YOUR_WEBSERVER_HOST_NAME', port: OPTIONAL_PORT }
    def fb_link
      default_url_options = if !Rails.application.routes.default_url_options.try(:empty?)
        Rails.application.routes.default_url_options
      elsif !Rails.application.config.action_controller.default_url_options.try(:empty?)
        Rails.application.config.action_controller.default_url_options
      end
      Spree::Core::Engine.routes.url_helpers.product_url(self, default_url_options)
    end

    def fb_title
      name
    end

    def fb_price_currency
      currency
    end

    def fb_brand
      brand.try(:name)
    end

    def fb_additional_image_link
      images = master_images[1..-1].to_a.map do |image|
        image_path = image.try(:attachment).try(:url, :large)
        image_path.blank? ? nil : ActionController::Base.helpers.asset_path(image_path)
      end
      images.empty? ? nil : images.compact.join(',')
    end

    def fb_age_group; end
    def fb_applink; end

    def fb_google_product_category
      # both category and brand have type Spree::Taxon and are interchangeble
      (category || brand).try(:pretty_name)
    end

    # TODO implement other fields
    def method_missing(name, *args, &block)
      return nil if name.to_s.start_with? 'fb_'
      super
    end

  end
end
