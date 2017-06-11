# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

# This migration comes from facebook_ads_engine (originally 20170223050516)
class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.bigint :pixel_id
      t.bigint :catalog_id
      t.bigint :merchant_settings_id

      t.timestamps
    end
  end
end
