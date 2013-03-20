class AddRecipientTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recipient_token, :string
  end
end
