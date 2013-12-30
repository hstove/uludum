class RemovePaidFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :paid
  end
end
