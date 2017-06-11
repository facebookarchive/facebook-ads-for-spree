# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

require 'spec_helper'
require 'cancan'
require 'spree/testing_support/bar_ability'


RSpec.describe Spree::Admin::FacebookSettingsController, type: :controller do

  context "with authorization" do
    render_views

    stub_authorization!

    describe "GET #index" do
      before do
        spree_get :index
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "has /admin/facebook_settings link in sidebar" do
        expect(response.body).to match /<li class="sidebar-menu-item"><a[^>]+\/admin\/facebook_settings/im
      end

      it "has 'Connect to Facebook' button" do
        expect(response.body).to match /<a class="btn btn-primary" href="javascript:openPopup\(\)">Connect to Facebook/im
      end
    end
  end
end
