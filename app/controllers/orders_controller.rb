class OrdersController < ApplicationController
  before_action :login_required

  def create
    @orderable = find_polymorphic(:orders)
    @order = Order.prefill!(@orderable, current_user)
    port = Rails.env.production? ? "" : ":3000"
    callback_url = "#{request.scheme}://#{request.host}#{port}/orders/postfill"
    amazon_opts = {}
    amazon_opts[:reserve] = @orderable.class == Fund ? true : false
    amazon_opts[:recipient_token] = @orderable.user.recipient_token
    amazon_opts[:transaction_amount] = @order.price
    amazon_opts[:payment_reason] = "Order for #{@orderable.title}"
    redirect_to AmazonFlexPay.single_use_pipeline(@order.uuid, callback_url, amazon_opts)
  end

end
