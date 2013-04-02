class AddExpirationToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :expiration, :datetime
  end
end
