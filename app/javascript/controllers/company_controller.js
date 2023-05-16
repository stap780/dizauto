import { Controller } from "@hotwired/stimulus"
import { get, post, patch } from "@rails/request.js"

export default class extends Controller {
    static targets = ['inn','bik' ]
    
    async dadata_company(e) {
        var inn = this.innTarget.value;
        //console.log(inn);
        var url = "https://dadata.ru/api/v2/suggest/party";
        var token = "c06864b3c1082f24e05f15e674b38c30f906b427";

        var options = {
                        method: "POST",
                        mode: "cors",
                        headers: {
                            "Content-Type": "application/json",
                            "Accept": "application/json",
                            "Authorization": "Token " + token
                        },
                        body: JSON.stringify({query: inn})
                    }
        // console.log(options);

        const innRequest = new Request(url, options);
        await fetch(innRequest)
            .then((response) => response.json())
            .then((data) => {
                //console.log(data);
                for (const comp of data.suggestions) {
                    document.getElementById('company_title').value = comp.data.name.full_with_opf;
                    document.getElementById('company_kpp').value = comp.data.kpp;
                    document.getElementById('company_ogrn').value = comp.data.ogrn;
                    document.getElementById('company_okpo').value = comp.data.okpo;
                    document.getElementById('company_ur_address').value = comp.data.address.data.postal_code+ ' ' + comp.data.address.value;
                }
            })
            .catch(console.error);
    }
    
    async dadata_bank(e) {
        var bik = this.bikTarget.value;
        console.log(bik);
        var url = "https://dadata.ru/api/v2/suggest/bank";
        var token = "c06864b3c1082f24e05f15e674b38c30f906b427";

        var options = {
                        method: "POST",
                        mode: "cors",
                        headers: {
                            "Content-Type": "application/json",
                            "Accept": "application/json",
                            "Authorization": "Token " + token
                        },
                        body: JSON.stringify({query: bik})
                    }
        // console.log(options);

        const bankRequest = new Request(url, options);
        await fetch(bankRequest)
            .then((response) => response.json())
            .then((data) => {
                console.log(data);
                for (const bank of data.suggestions) {
                    document.getElementById('company_bank_title').value = bank.data.name.payment;
                }
            })
            .catch(console.error);
    }

}