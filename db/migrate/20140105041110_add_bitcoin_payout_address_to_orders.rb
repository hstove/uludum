class AddBitcoinPayoutAddressToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :bitcoin_payout_address, :string
  end
end
