class AddCoinbaseCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :coinbase_code, :string
    add_column :orders, :bitcoin_amount, :float
  end
end
