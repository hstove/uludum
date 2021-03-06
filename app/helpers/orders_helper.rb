module OrdersHelper
  def coinbase_button order, user
    return '' if order.orderable.user.bitcoin_address.blank?
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
    if orderable.orders.empty?
      return content_tag(:p, "No orders have been made for this fund.")
    end
    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.series name: "Orders", data: orderable.payment_growth, marker: {enabled: false}
    end
    high_chart id, chart
  end

  def growth_chart
    chart = LazyHighCharts::HighChart.new('graph') do |f|
      [Order, Enrollment].each do |clazz|
        if clazz.respond_to?(:cumulative_growth)
          f.series name: "#{clazz}s", data: clazz.cumulative_growth,
            yAxis: 1
        end
        data = clazz.weekly_growth
        f.series name: "#{clazz} WoW Growth", data: data
        f.series name: "Average #{clazz} Growth", data: make_averages(data), type: :line
      end
      f.title text: "Weekly Growth"
      f.legend = {enabled: true}
      f.chart(zoomType: 'x')
      f.xAxis(maxZoom: 14 * 24 * 3600000)
    end
    high_chart 'revenue-chart', chart
  end

  private

  def make_averages data
    average = data.inject do |sum, week|
      week[1] # growth
    end.to_f / data.size.to_f * 100.0
    data.map do |week|
      [week[0], average]
    end
  end
end
