class AddDefaultStateToOrders < ActiveRecord::Migration
  def change
    Order.update_all "state = 'pending'"
    Order.where(paid: true).update_all "state = 'finished'"
    Order.where("paid is not true").each do |order|
      order.complete!
    end
  end
end
