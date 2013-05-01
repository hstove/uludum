class OrdersController < ApplicationController
  before_filter :login_required
  before_filter :stripe_required, only: [:create]

  def new
    @orderable = find_polymorphic(:orders)
    @order = @orderable.orders.new
    @order.user = current_user
  end

  def create
    @orderable = find_polymorphic(:orders, except: User)
    @order = @orderable.orders.new
    @order.user_id = current_user.id
    @order.price = params[:order][:price]
    if @order.save
      track_charge @order
      flash[:notice] = "Your have successfully created an order for #{@orderable.title}."
    else
      flash[:alert] = "There was an error creating your order for #{@orderable.title}"
    end
    redirect_to @orderable
  end

  def index
    if params[:payment]
      @orders = current_user.payments
    else
      @orders = current_user.orders.order("created_at desc")
    end

    @sum = 0
    @orders.each { |o| @sum += o.price }
  end

  def show
    @order = Order.find(params[:id])
    authorize! :read, @order
    @orderable = @order.orderable
  end

  private

  def stripe_required
    if current_user.stripe_customer_id.nil?
      redirect_to payment_path, alert: "You must configure your payment information before ordering."
    end
  end

end
