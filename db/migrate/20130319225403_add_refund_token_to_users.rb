class AddRefundTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :refund_token, :string
  end
end
