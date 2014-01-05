require 'spec_helper'

describe CoinbaseController do
  describe "#callback" do
    let(:user) { create :user }
    let(:orderable) { create :fund }

    let(:params) {
      {
        order: {
          id: "5RTQNACF",
          created_at: "2012-12-09T21:23:41-08:00",
          status: "completed",
          total_btc: {
            cents: 100000000,
            currency_iso: "BTC"
          },
          total_native: {
            cents: 1000,
            currency_iso: "USD"
          },
          custom: "#{user.id}-#{orderable.class}-#{orderable.id}",
          receive_address: "1NhwPYPgoPwr5hynRAsto5ZgEcw1LzM3My",
          button: {
            type: "buy_now",
            name: "Alpaca Socks",
            description: "The ultimate in lightweight footwear",
            id: "5d37a3b61914d6d0ad15b5135d80c19f"
          },
          transaction: {
            id: "514f18b7a5ea3d630a00000f",
            hash: "4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b",
            confirmations: 0
          },
          customer: {
            email: "[email protected]",
            shipping_address: [
              "John Smith",
              "123 Main St.",
              "Springfield OR 97477",
              "United States"
            ]
          }
        }
      }
    }

    it "creates a new order when it should" do
      post :callback, params
      order = user.orders.reload.find{|o| o.orderable_id == orderable.id }
      order.should_not be_nil
      order.price.should eql(10.0)
      order.coinbase_id.should eql("5RTQNACF")
      order.coinbase_code.should eql("5d37a3b61914d6d0ad15b5135d80c19f")
      order.bitcoin_amount.should eql(1.0)
      order.bitcoin_payout_address.should eql(orderable.user.bitcoin_address)
      order.finished?.should == true
    end

    it "returns 200" do
      post :callback, params
      response.should be_success
    end
  end
end
