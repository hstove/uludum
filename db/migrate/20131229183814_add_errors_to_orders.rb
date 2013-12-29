class AddErrorsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :state, :string
    add_column :orders, :error, :text
  end
end
