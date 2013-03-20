class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :orderable_type
      t.integer :orderable_id
      t.string :uuid
      t.integer :user_id
      t.string :status
      t.string :token
      t.float :price
      t.string :recipient_id

      t.timestamps
    end
  end
end
