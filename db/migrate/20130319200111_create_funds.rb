class CreateFunds < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.integer :user_id
      t.text :body
      t.float :goal
      t.datetime :goal_date
      t.boolean :hidden
      t.float :price

      t.timestamps
    end
  end
end
