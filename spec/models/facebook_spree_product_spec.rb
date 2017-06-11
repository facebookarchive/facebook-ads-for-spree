# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

require 'spec_helper'

describe Spree::Product, type: :model do
  let!(:product) { create(:product) }

  describe '#to_facebook_product_item' do
    it 'should return correct facebook product fields' do
      fb_product = product.to_facebook_product_item
      expect(fb_product[:link]).to eq("http://localhost:3000/products/#{product.slug}")
      expect(fb_product[:description]).to eq(product.description)
      expect(fb_product[:title]).to eq(product.name)
      expect(fb_product[:id]).to eq("Spree::Product-1")
      expect(fb_product[:price]).to eq(19.99.to_d)
      expect(fb_product[:price_currency]).to eq("USD")
      expect(fb_product[:availability]).to eq("in stock")
      expect(fb_product[:condition]).to eq("new")
    end
  end
end