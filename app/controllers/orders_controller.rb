class OrdersController < ApplicationController
  before_action :login_required

  def create
    @orderable = find_polymorphic(:orders)
    price = params[:order] && params[:order][:price] ? params[:order][:price] : nil
    @order = Order.prefill!(@orderable, current_user, price)
    port = Rails.env.production? ? "" : ":3000"
    callback_url = "#{request.scheme}://#{request.host}#{port}/orders/postfill"
    amazon_opts = {}
    amazon_opts[:recipient_token] = @orderable.user.recipient_token
    amazon_opts[:transaction_amount] = @order.price
    amazon_opts[:payment_reason] = "Order for #{@orderable.title}"
    redirect_to AmazonFlexPay.single_use_pipeline(@order.uuid, callback_url, amazon_opts)
  end

  def postfill
    unless params[:callerReference].blank?
      @order = Order.postfill!(params)
    end
    # "A" means the user cancelled the preorder before clicking "Confirm" on Amazon Payments.
    if params['status'] != 'A' && @order.present?
      flash[:notice] = "We've completed your order for #{@order.orderable.title}. Thanks for your support!"
      redirect_to @order.orderable
    else
      flash[:alert] = "We were unable to complete your order."
      redirect_to funds_path
    end
  end

  def index
    if params[:payment]
      @orders = current_user.payments
    else
      @orders = current_user.orders
    end

    @sum = 0
    @orders.each { |o| @sum += o.price }
  end

end
