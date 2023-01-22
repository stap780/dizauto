// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

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


