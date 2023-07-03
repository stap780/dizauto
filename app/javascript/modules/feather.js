// Usage: https://feathericons.com/
import feather from "feather-icons";

//document.addEventListener("DOMContentLoaded", () => {
//    feather.replace();
//});

document.addEventListener("turbo:load", () => {
    feather.replace();
});

window.feather = feather;