import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {

  connect() {
    console.log("connected flatpikr")
    //console.log("connected flatpikr", this.element)
 
     flatpickr(".flatpickr", {
      enableTime: true,
      time_24hr: true,
      defaultHour: '09',
      // human friendly date with time (EG: April 24, 2021 12:00 PM)
      dateFormat: "d-m-Y H:i",
      disable: [
        // function (date) {
        //   // return true to disable
        //   return date.getDay() === 0 || date.getDay() === 6;
        // },
      ],
      locale: {
        firstDayOfWeek: 1, // start week on Monday
      },
    });

   }


}
