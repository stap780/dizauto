import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calculate"

// take example from here - https://github.com/ricardovelero/invoicing-rails/blob/main/app/javascript/controllers/recalculate_controller.js
export default class extends Controller {
  static targets = [
    "qty",
    "price",
    "discount",
    "vat",
    "sum",
    "subtotal",
    "vattotal",
    "total",
  ];

  connect() {
    console.log('calculate')
    // const langAttribute = document.documentElement.lang;
    // this.currency = langAttribute === "es" ? "EUR" : "USD";
    // this.format = langAttribute === "es" ? "es-ES" : "en-US";
    this.currency = "RUB";
    this.format = "ru-RU";
  }

  recalculate(event) {
    const formatter = new Intl.NumberFormat(this.format, {
      style: "currency",
      currency: this.currency,
    });
    
    let itemTotal = 0;
    let subTotal = 0;
    let totalTotal = 0;
    let vatArray = [];
    let qtysArray = [];
    let pricesArray = [];
    let discountArray = [];


    this.vatTargets.forEach((vat, index) => {
      vatArray[index] = vat.value.trim() * 1;
    });

    this.qtyTargets.forEach((qty, index) => {
      qtysArray[index] = qty.value;
    });

    this.priceTargets.forEach((price, index) => {
      pricesArray[index] = price.value;
    });

    this.discountTargets.forEach((discount, index) => {
      discountArray[index] = discount.value;
    });


    this.sumTargets.forEach((element, index) => {
      // price vat exclude
      // itemTotal = pricesArray[index] * (1 + vatArray[index] / 100) * qtysArray[index] ;
      // element.value = itemTotal.toFixed(2);
      // totalTotal += itemTotal;
      // subTotal += itemTotal / (1 + vatArray[index] / 100);
      //
      //
      // price vat include
      let discount = 1;
      if (discountArray[index] > 0) {
        discount = 1 - discountArray[index] / 100;
      }
      let itemVat = (100 + vatArray[index]) / 100;

      itemTotal = pricesArray[index] * qtysArray[index] * discount;
      element.value = itemTotal.toFixed(2);
      totalTotal += itemTotal;
      subTotal += itemTotal / itemVat;
    });

    this.subtotalTarget.textContent = formatter.format(subTotal);
    this.vattotalTarget.textContent = formatter.format(totalTotal - subTotal);
    this.totalTarget.textContent = formatter.format(totalTotal);

  }

  convertNum(element) {
    return (
      element
        .replace("$", "")
        .replace("€", "")
        .replace("&euro", "")
        //.replace(".", "")
        .replace(",", ".")
        .trim() * 1
    );
  }

}

