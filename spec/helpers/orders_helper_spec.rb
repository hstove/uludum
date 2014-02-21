require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the OrdersHelper. For example:
#
# describe OrdersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe OrdersHelper do
  describe "#coinbase_button" do
    it "calls coinbase.create_button correctly" do
      orderable = create :fund
      order = orderable.orders.new
      order.price = orderable.price
      user = create :user
      user.bitcoin_address = nil
      coinbase = Rails.configuration.coinbase
      response = Hashie::Mash.new(button: {code: "hi-code"})
      title = orderable.title
      money = orderable.price.to_money("USD")
      options = {
        "data-button-style" => "custom_small"
      }
      custom = "#{user.id}-#{orderable.class}-#{orderable.id}"
      coinbase.should_receive(:create_button){ response }.with(title, money, nil, custom, options)
      html = helper.coinbase_button(order, user)
      html.should include("hi-code")
      html.should include('data-button-style="custom_small"')
    end
  end
end
