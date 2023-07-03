// Usage: https://apexcharts.com/docs/
import ApexCharts from "apexcharts";

window.ApexCharts = ApexCharts;

//document.addEventListener("DOMContentLoaded", function() {
document.addEventListener('turbo:load', function() {
  window.Apex = {
    colors: [
      window.theme.primary,
      window.theme.success,
      window.theme.warning,
      window.theme.danger,
      window.theme.info
    ],
    chart: {
      foreColor: window.theme["gray-600"]
    }
  };

  
  // Force redraw
  setTimeout(() => {
    window.dispatchEvent(new Event("resize"));
  }, 250);
});