module SpecMacros
  def new_stripe_customer user=nil
    user ||= create :user
    card = {
      number: "4242424242424242",
      exp_month: 12,
      exp_year: 2020,
    }
    user.create_stripe_customer card
    user
  end
end