class AddWillingnessToPayToWishVotes < ActiveRecord::Migration
  def change
    add_column :wish_votes, :willingness_to_pay, :float
  end
end
