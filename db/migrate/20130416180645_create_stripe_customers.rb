class CreateStripeCustomers < ActiveRecord::Migration
  def change
    create_table :stripe_customers do |t|
      t.integer :teacher_id
      t.integer :user_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
