$(function () {
  drawMostFailedChart();
  drawScoreFrequencyChart();
  $("a.navbar-brand").click(function(){
    setTimeout(function(){
      drawMostFailedChart();
      drawScoreFrequencyChart();
    }, 1000);
  });
  function drawMostFailedChart(){
    $("span.icon-repeat").click(function(){
      $(this).closest("form").submit();
    });
    json_data = $("#most-failed-questions-chart").data("most-failed-qs");
    data = [];
    for(var i in json_data){
      data.push({
        name: "#" + json_data[i].id,
        y: parseInt(json_data[i].frequency),
        url: json_data[i].url
      });
    }
    $("#most-failed-questions-chart").highcharts({
      chart: {
        type: "column"
      },
      title: {
        text: $("#most-failed-questions-chart").data("title")
      },
      xAxis: {
        type: "category",
        labels: {
          rotation: 0,
          style: {
            fontSize: "13px",
            fontFamily: "Verdana, sans-serif"
          }
        }
      },
      plotOptions: {
        series: {
          cursor: 'pointer',
          point: {
            events: {
              click: function () {
                location.href = this.options.url;
              }
            }
          }
        }
      },
      yAxis: {
        allowDecimals: false,
        min: 0,
        title: {
          text: $("#most-failed-questions-chart").data("yaxis-title")
        }
      },
      legend: {
        enabled: false
      },
      series: [{
        name: $("#most-failed-questions-chart").data("series-name"),
        data: data,
        dataLabels: {
          enabled: true,
          rotation: -90,
          color: "#FFFFFF",
          align: "right",
          y: 10,
          style: {
            fontSize: "13px",
            fontFamily: "Times, sans-serif"
          }
        }
      }]
    });
  }

  function drawScoreFrequencyChart(){
    score_data = $("#score-line-chart").data("score-frequency");
      $("#score-line-chart").highcharts({
        chart: {
          type: "line"
        },
        title: {
          text: $("#score-line-chart").data("title")
        },
        xAxis: {
          categories: scores = score_data.map(function(e){ return e[0]})
        },
        yAxis: {
          allowDecimals: false,
          title: {
            text: $("#score-line-chart").data("yaxis-title")
          }
        },
        plotOptions: {
          line: {
            dataLabels: {
              enabled: false
            },
            enableMouseTracking: true
          }
        },
        series: [{
          name: "Score frequency",
          data: score_data.map(function(e){ return e[1]})
        }]
    });
  }
});
