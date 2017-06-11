# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

require 'spec_helper'

GENERIC_PIXEL_CODE_PATTERN = /fbq\('init', '123'\)/

describe Spree::ProductsController, type: :controller do
  VIEW_CONTENT_PATTERN = /fbq\('track', 'ViewContent', \{"content_ids":\["Spree::Product-\d+"\],"content_name":"Product #\d+ - \d+","content_type":"product","currency":"USD","value":"19.99"\}\);/
  ADD_TO_CART_PATTERN = /fbq\('track', 'AddToCart', \{"content_ids":\["Spree::Product-\d+"\],"content_name":"Product #\d+ - \d+","content_type":"product","currency":"USD","value":"19.99"\}\);/

  let!(:product) { create(:product) }

  render_views

  context "without installed pixel" do
    before do
      spree_get :show, id: product.to_param
      expect(response.status).to eq(200)
    end

    it "shouldn't render generic pixel code" do
      expect(response.body).to_not match GENERIC_PIXEL_CODE_PATTERN
    end

    it "shouldn't render ViewContent pixel" do
      expect(response.body).to_not match(VIEW_CONTENT_PATTERN)
    end

    it "shouldn't render AddToCart pixel" do
      expect(response.body).to_not match(ADD_TO_CART_PATTERN)
    end
  end

  context "with installed pixel" do
    let!(:setting) { Setting.create(pixel_id: 123) }

    before do
      spree_get :show, id: product.to_param
      expect(response.status).to eq(200)
    end

    it "should render generic pixel code" do
      expect(response.body).to match GENERIC_PIXEL_CODE_PATTERN
    end

    it "should render ViewContent pixel" do
      expect(response.body).to match(VIEW_CONTENT_PATTERN)
    end

    it "should render AddToCart pixel" do
      expect(response.body).to match(ADD_TO_CART_PATTERN)
    end
  end
end

describe Spree::OrdersController, type: :controller do
  INITIATE_CHECKOUT_PATTERN = /fbq\('track', 'InitiateCheckout', \{"content_category":null,"content_ids":\["Spree::Product-\d+"\],"content_name":"Product #\d+ - \d+","currency":"USD","value":"99.95","num_items":5\}\);/

  let(:variant) { create(:variant) }

  render_views

  context "without installed pixel" do
    before do
      spree_post :populate, variant_id: variant.id, quantity: 5
      spree_get :edit
      expect(response.status).to eq(200)
    end

    it "shouldn't render generic pixel code" do
      expect(response.body).to_not match GENERIC_PIXEL_CODE_PATTERN
    end

    it "shouldn't trigger InitiateCheckout" do
      expect(response.body).to_not match INITIATE_CHECKOUT_PATTERN
    end
  end

  context "with installed pixel" do
    let!(:setting) { Setting.create(pixel_id: 123) }
    before do
      spree_post :populate, variant_id: variant.id, quantity: 5
      spree_get :edit
      expect(response.status).to eq(200)
    end

    it "should render generic pixel code" do
      expect(response.body).to match GENERIC_PIXEL_CODE_PATTERN
    end

    it "should trigger InitiateCheckout" do
      expect(response.body).to match INITIATE_CHECKOUT_PATTERN
    end
  end
end

describe Spree::CheckoutController, type: :controller do
  PURCHASE_PIXEL_PATTERN = /fbq\('track', 'Purchase', \{"content_ids":\["Spree::Product-\d+","Spree::Product-\d+"\],"content_name":"Product #\d+ - \d+","content_type":"product","currency":"USD","num_items":2,"value":"0.0"\}\);/

  let(:user) { stub_model(Spree::LegacyUser) }
  let(:order) { FactoryGirl.create(:order_with_totals) }

  context "in confirm state" do
    render_views

    before do
      allow(controller).to receive_messages try_spree_current_user: user
      allow(controller).to receive_messages spree_current_user: user
      allow(controller).to receive_messages current_order: order

      allow(order).to receive(:available_shipping_methods).
          and_return [stub_model(Spree::ShippingMethod)]
      allow(order).to receive(:available_payment_methods).
          and_return [stub_model(Spree::PaymentMethod)]
      allow(order).to receive(:ensure_available_shipping_rates).
          and_return true
      order.line_items << FactoryGirl.create(:line_item)

      allow(order).to receive_messages confirmation_required?: true
      order.update_column(:state, "confirm")
      allow(order).to receive_messages user: user
      # An order requires a payment to reach the complete state
      # This is because payment_required? is true on the order
      create(:payment, amount: order.total, order: order)
      order.payments.reload
      # addresses should not be empty to reder views
      order.bill_address = create(:address)
      order.ship_address = create(:address)
    end

    context "with installed pixel" do
      let!(:setting) { Setting.create(pixel_id: 123) }
      before do
        spree_get :edit
      end
      it "should render 'Purchased' pixel" do
        expect(response.body).to match PURCHASE_PIXEL_PATTERN
      end
      it "should render generic pixel code" do
        expect(response.body).to match GENERIC_PIXEL_CODE_PATTERN
      end
    end

    context "without installed pixel" do
      before do
        spree_get :edit
      end
      it "shouldn't render 'Purchased' pixel" do
        expect(response.body).to_not match PURCHASE_PIXEL_PATTERN
      end
      it "shouldn't render generic pixel code" do
        expect(response.body).to_not match GENERIC_PIXEL_CODE_PATTERN
      end
    end
  end
end