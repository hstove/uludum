module OrdersHelper
  def coinbase_button order, user
    title = "Order for #{order.orderable.title}"
    custom = "#{user.id}-#{order.orderable.class}-#{order.orderable_id}"
    coinbase = Rails.configuration.coinbase
    options = {
      "data-button-style" => "custom_small"
    }
    price = order.price || order.orderable.price
    r = coinbase.create_button title, price.to_money("USD"), nil, custom, options
    a_opts = {
      data: {
        code: r.button.code,
        "button-style" => "custom_small",
      },
      class: "coinbase-button btn btn-large",
    }
    a_tag = link_to "Checkout with Bitcoin", "https://coinbase.com/checkouts/#{r.button.code}", a_opts
    script_tag = javascript_include_tag("https://coinbase.com/assets/button.js")
    a_tag + script_tag
  end
end
