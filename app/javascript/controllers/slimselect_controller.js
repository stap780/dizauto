import { Controller } from "@hotwired/stimulus"
import { get, post } from "@rails/request.js"
import SlimSelect from 'slim-select'

// Connects to data-controller="slim-select"
export default class extends Controller {

  //[ 'property','characteristic','client' ]
  connect() {
    // console.log( 'connect slimselect' );
    // console.log( 'this from slimselect', this )
    // console.log( 'this.element', this.element )
    const searchUrl = this.element.dataset.searchUrl ;
    // console.log( 'searchUrl', searchUrl );

    if (searchUrl != undefined ){
      this.slimselect = new SlimSelect({
        select: this.element,
        settings: {
          //minSelected: 1,
          maxSelected: 1,
        },
        events: {
          search: (search, currentData) => {
            return new Promise((resolve, reject) => {
              if (search.length < 2) {
                return reject('Search must be at least 2 characters')
              }

              post(searchUrl, {
                body: JSON.stringify({
                  title: search,
                }),
              })
                .then((response) => response.json
                // {
                //   console.log( 'response', response );
                //   const body = response.json
                //   console.log( 'body', body );
                //   body
                //   }
                )
                .then((data) => {
                  console.log( 'data', data );
                  const options = data.map((d) => {
                    return {
                      text: `${d.title}`,
                      value: `${d.id}`,
                    }
                  })

                  resolve(options);
                })
            })
          },
          afterChange: (newVal) => {
            console.log('newVal',newVal)
            var selectId = this.element.getAttribute('id') //closest('tr').getAttribute('id')
            console.log('selectId', selectId)
            let params = new URLSearchParams()
            params.append("selectId", selectId)
            params.append("product_id", newVal[0].value)
            
            get(`/orders/nested_item?${params}`, {
              responseKind: "turbo-stream"
            })
          }
        }

      })  
    } else {

      this.slimselect = new SlimSelect({
        select: this.element,
        settings: {
          //minSelected: 1,
          maxSelected: 1,
        },
        events: {
          events: {
            afterChange: (newVal) => {
              console.log(newVal)
            }
          }
        }
      })
  
    }

  }


}

