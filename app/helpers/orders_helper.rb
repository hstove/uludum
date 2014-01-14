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
    last_week = 0
    last_week_date = nil
    week_diff = 0
    revenue = Order.group("DATE_TRUNC('week', created_at)").sum(:price).to_enum.with_index.map do |week, index|
      growth = ((week[1] - last_week) / last_week) * 100
      if last_week_date
        growth /= ((week.first - last_week_date) / 1.week)
        week_diff = ((week.first - last_week_date) / 1.week)
      end
      growth = 1 if growth.infinite?
      last_week_date = week.first
      last_week = week[1]
      [week.first.to_time.to_i * 1000, growth]
    end
    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.series name: "Revenue week-over-week Growth", data: revenue, marker: {enabled: false}
      f.chart[:title] = {text: "Weekly Revenue Growth"}
    end
    high_chart 'revenue-chart', chart
  end
end
