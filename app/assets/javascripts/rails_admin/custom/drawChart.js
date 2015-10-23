$(function () {
  drawChart();
  $("a.navbar-brand").click(function(){
    setTimeout(function(){
      drawChart();
    }, 1000);
  });
  function drawChart(){
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

});
