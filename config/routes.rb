# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

Spree::Core::Engine.add_routes do
  namespace :admin, path: Spree.admin_path do
    resources :facebook_settings do
      collection do
        post :update_settings
      end
    end
  end
end
