class AddUserIdToProgresses < ActiveRecord::Migration
  def change
    add_column :progresses, :user_id, :integer
  end
end
