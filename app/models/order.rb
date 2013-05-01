class Order < ActiveRecord::Base
  include MixpanelHelpers
  validates_presence_of :user_id, :orderable_type, :orderable_id, :price
  belongs_to :orderable, polymorphic: true
  belongs_to :user

  scope :completed, -> { where("token != ? OR token != ?", "", nil) }
  scope :grouped, -> { group("user_id").select("sum(price) as sum").select("user_id") }


  after_save do
    if paid == true && paid_changed?
      autoenroll
      UserMailer.order_complete(self).deliver
    end
  end

  after_create do
    if orderable.class == Course
      complete
    end
  end

  def complete
    return false if self.paid == true
    begin
      token = Stripe::Token.create({customer: user.stripe_customer_id}, orderable.user.stripe_key) 

      charge = Stripe::Charge.create({
        amount: (price * 100).to_i,
        currency: "usd",
        card: token.id,
        description: "Order for #{orderable.title.titleize}",
        application_fee: order_fee
      }, orderable.user.stripe_key)
      self.paid = true
      save!
    rescue Stripe::StripeError => e
      ap "Error completing payment!!!"
      ap e.message
    end
    self
  end

  def status
    if orderable == fund && paid != true
      return "waiting for fund completion"
    end
    if paid != true
      return "processing"
    elsif paid == true
      return "completed"
    end
  end

  def order_fee
    ((price * 0.05) * 100).to_i
  end

  private

  def autoenroll
    if orderable.class == Course && price >= orderable.price
      user.enroll orderable
    end
  end

end
