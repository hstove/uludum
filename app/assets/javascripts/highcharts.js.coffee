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
      enabled: false
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
    plotOptions:
      column:
        pointWidth: 10
    yAxis:
      gridLineWidth: 0
      lineWidth: 1
      lineColor: "#435061"
      labels:
        formatter: ->
          "$#{@value}"
    tooltip:
      formatter: ->
        "$#{Highcharts.numberFormat(@y, 0)}"