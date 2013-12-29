class AddDefaultStateToOrders < ActiveRecord::Migration
  def change
    Order.update_all "state = 'pending'"
    Order.where(paid: true).update_all "state = 'finished'"
    Order.pending.each do |order|
      order.complete!
    end
  end
end
