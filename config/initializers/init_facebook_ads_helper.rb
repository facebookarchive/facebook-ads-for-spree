# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

FacebookAdsHelper.module_eval do

  # Default implementation of product_models cannot find Spree::Product
  def product_models
    [Spree::Product]
  end
end