$ ->
  Highcharts.setOptions
    chart:
      type: 'column'
      borderRadius: 0
      backgroundColor: "whiteSmoke"
    title:
      text: "Orders"
      style:
        "font-family": "Roboto"
    legend:
      enabled: true
      align: 'right'
      verticalAlign: 'top'
      floating: true
    colors: [
      '#435061'
      '#AA4643'
      '#89A54E'
      '#80699B'
      '#3D96AE'
      '#DB843D'
      '#92A8CD'
      '#A47D7C'
      '#B5CA92'
    ]
    credits:
      enabled: false
    xAxis:
      type: 'datetime'
      lineWidth: 1
      tickWidth: 0
      lineColor: "#435061"
      min: 1385884800000 # December 2013
    plotOptions:
      series:
        marker:
          enabled: false
    yAxis: [
      gridLineWidth: 0
      lineWidth: 1
      lineColor: "#435061"
      max: 50
      labels:
        formatter: ->
          if @chart.title.text == "Weekly Growth"
            "#{@value}%"
          else
            "$#{@value}"
    ,
      opposite: true
    ]
    tooltip:
      formatter: ->
        if (@series.chart.title.text == "Weekly Growth") and (@series?.options.yAxis != 1)
          "<b>#{@series.name}</b>: #{@y}%<br>#{moment(@x).format("MMMM Do YYYY")}"
        else
          "<b>#{@series.name}</b>: #{Highcharts.numberFormat(@y, 0)}"