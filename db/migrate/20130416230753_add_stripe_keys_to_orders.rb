class AddStripeKeysToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :stripe_customer_id, :string
    add_column :orders, :stripe_charge_id, :string
  end
end
