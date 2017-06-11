# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

# This migration comes from spree (originally 20141120135441)
class AddGuestTokenIndexToSpreeOrders < ActiveRecord::Migration[4.2]
  def change
    add_index :spree_orders, :guest_token
  end
end
