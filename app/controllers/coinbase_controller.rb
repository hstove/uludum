class CoinbaseController < ApplicationController
  def callback
    custom = params[:order][:custom].split("-")
    user = User.find(custom[0])
    orderable = custom[1].constantize.find(custom.last)
    order = user.orders.new
    order.orderable = orderable
    order.price = params[:order][:total_native][:cents].to_i / 100
    order.coinbase_id = params[:order][:id]
    order.coinbase_code = params[:order][:button][:id]
    order.bitcoin_amount = params[:order][:total_btc][:cents].to_f / 100000000.0
    order.bitcoin_payout_address = orderable.user.bitcoin_address
    order.finish!
    render nothing: true, status: 200
  end
end
