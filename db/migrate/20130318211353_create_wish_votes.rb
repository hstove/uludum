class CreateWishVotes < ActiveRecord::Migration
  def change
    create_table :wish_votes do |t|
      t.integer :user_id
      t.integer :wish_id

      t.timestamps
    end
  end
end
