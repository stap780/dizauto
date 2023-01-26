// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

import "./modules/sidebar"
import "./modules/theme"
import "./modules/feather"
 
// Charts
import "./modules/chartjs"
 
// Forms
import "./modules/flatpickr"
 
// // Maps
// import "./modules/vector-maps"

window.bootstrap = bootstrap;

document.addEventListener('turbo:load', () => {
  console.log("DOM готов!");
  
  // var modal = new bootstrap.Modal('#typeForm');
  // document.addEventListener('closeModal', () => {
  //     modal.hide();
  // });


  const alertList = document.querySelectorAll('.alert');
  if (alertList) {
    const alerts = [...alertList].map(element => new bootstrap.Alert(element));
    // console.log(alerts);
    for (const alert of alerts) {
      // console.log(alert);
      setTimeout(() => {
        alert.close();
      }, 3000); // time in milliseconds  
    };
  }


});

document.addEventListener('turbo:load', function() {
  var ctx = document.getElementById("chartjs-dashboard-line").getContext("2d");
  var gradientLight = ctx.createLinearGradient(0, 0, 0, 225);
  gradientLight.addColorStop(0, "rgba(215, 227, 244, 1)");
  gradientLight.addColorStop(1, "rgba(215, 227, 244, 0)");
  var gradientDark = ctx.createLinearGradient(0, 0, 0, 225);
  gradientDark.addColorStop(0, "rgba(51, 66, 84, 1)");
  gradientDark.addColorStop(1, "rgba(51, 66, 84, 0)");
  // Line chart
  new Chart(document.getElementById("chartjs-dashboard-line"), {
    type: "line",
    data: {
      labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
      datasets: [{
        label: "Sales ($)",
        fill: true,
        backgroundColor: window.theme.id === "light" ? gradientLight : gradientDark,
        borderColor: window.theme.primary,
        data: [
          2115,
          1562,
          1584,
          1892,
          1587,
          1923,
          2566,
          2448,
          2805,
          3438,
          2917,
          3327
        ]
      }]
    },
    options: {
      maintainAspectRatio: false,
      legend: {
        display: false
      },
      tooltips: {
        intersect: false
      },
      hover: {
        intersect: true
      },
      plugins: {
        filler: {
          propagate: false
        }
      },
      scales: {
        xAxes: [{
          reverse: true,
          gridLines: {
            color: "rgba(0,0,0,0.0)"
          }
        }],
        yAxes: [{
          ticks: {
            stepSize: 1000
          },
          display: true,
          borderDash: [3, 3],
          gridLines: {
            color: "rgba(0,0,0,0.0)",
            fontColor: "#fff"
          }
        }]
      }
    }
  });
});

document.addEventListener('turbo:load', function() {
  // Pie chart
  new Chart(document.getElementById("chartjs-dashboard-pie"), {
    type: "pie",
    data: {
      labels: ["Chrome", "Firefox", "IE", "Other"],
      datasets: [{
        data: [4306, 3801, 1689, 3251],
        backgroundColor: [
          window.theme.primary,
          window.theme.warning,
          window.theme.danger,
          "#E8EAED"
        ],
        borderWidth: 5,
        borderColor: window.theme.white
      }]
    },
    options: {
      responsive: !window.MSInputMethodContext,
      maintainAspectRatio: false,
      legend: {
        display: false
      },
      cutoutPercentage: 70
    }
  });
});

document.addEventListener('turbo:load', function() {
  // Bar chart
  new Chart(document.getElementById("chartjs-dashboard-bar"), {
    type: "bar",
    data: {
      labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
      datasets: [{
        label: "This year",
        backgroundColor: window.theme.primary,
        borderColor: window.theme.primary,
        hoverBackgroundColor: window.theme.primary,
        hoverBorderColor: window.theme.primary,
        data: [54, 67, 41, 55, 62, 45, 55, 73, 60, 76, 48, 79],
        barPercentage: .75,
        categoryPercentage: .5
      }]
    },
    options: {
      maintainAspectRatio: false,
      legend: {
        display: false
      },
      scales: {
        yAxes: [{
          gridLines: {
            display: false
          },
          stacked: false,
          ticks: {
            stepSize: 20
          }
        }],
        xAxes: [{
          stacked: false,
          gridLines: {
            color: "transparent"
          }
        }]
      }
    }
  });
});

document.addEventListener('turbo:load', function() {
  var markers = [{
      coords: [31.230391, 121.473701],
      name: "Shanghai"
    },
    {
      coords: [28.704060, 77.102493],
      name: "Delhi"
    },
    {
      coords: [6.524379, 3.379206],
      name: "Lagos"
    },
    {
      coords: [35.689487, 139.691711],
      name: "Tokyo"
    },
    {
      coords: [23.129110, 113.264381],
      name: "Guangzhou"
    },
    {
      coords: [40.7127837, -74.0059413],
      name: "New York"
    },
    {
      coords: [34.052235, -118.243683],
      name: "Los Angeles"
    },
    {
      coords: [41.878113, -87.629799],
      name: "Chicago"
    },
    {
      coords: [51.507351, -0.127758],
      name: "London"
    },
    {
      coords: [40.416775, -3.703790],
      name: "Madrid "
    }
  ];
  var map = new jsVectorMap({
    map: "world",
    selector: "#world_map",
    zoomButtons: true,
    markers: markers,
    markerStyle: {
      initial: {
        r: 9,
        stroke: window.theme.white,
        strokeWidth: 7,
        stokeOpacity: .4,
        fill: window.theme.primary
      },
      hover: {
        fill: window.theme.primary,
        stroke: window.theme.primary
      }
    },
    regionStyle: {
      initial: {
        fill: window.theme["gray-200"]
      }
    },
    zoomOnScroll: false
  });
  window.addEventListener("resize", () => {
    map.updateSize();
  });
  setTimeout(function() {
    map.updateSize();
  }, 250);
});

document.addEventListener('turbo:load', function() {
  var date = new Date(Date.now() - 5 * 24 * 60 * 60 * 1000);
  var defaultDate = date.getUTCFullYear() + "-" + (date.getUTCMonth() + 1) + "-" + date.getUTCDate();
  document.getElementById("datetimepicker-dashboard").flatpickr({
    inline: true,
    prevArrow: "<span class=\"fas fa-chevron-left\" title=\"Previous month\"></span>",
    nextArrow: "<span class=\"fas fa-chevron-right\" title=\"Next month\"></span>",
    defaultDate: defaultDate
  });
});

