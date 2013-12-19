class AddCoinbaseIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :coinbase_id, :string
  end
end
