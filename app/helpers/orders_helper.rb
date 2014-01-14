module OrdersHelper
  def coinbase_button order, user
    title = order.orderable.title
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

  def order_chart orderable, id="order-chart"
    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.series name: "Orders", data: orderable.payment_growth, marker: {enabled: false}
    end
    high_chart id, chart
  end

  def revenue_chart
    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.series name: "Revenue WoW Growth", data: Order.weekly_revenue, marker: {enabled: false}, stack: "revenue"
      f.series name: "Enrollment WoW growth", data: Enrollment.weekly_growth, marker: {enabled: false}, stack: "enrollments"
      f.chart[:title] = {text: "Weekly Growth"}
      f.plotOptions[:column] = {stacking: :normal}
      f.legend = {enabled: true}
      f.yAxis = {gridLineWidth: 3, lineWidth: 3}
    end
    high_chart 'revenue-chart', chart
  end
end
