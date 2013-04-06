class AddLoginTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_login, :datetime
    add_column :users, :last_login_attempt, :datetime
  end
end
