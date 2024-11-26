import { Controller } from "@hotwired/stimulus"
import { get, post } from "@rails/request.js"
import SlimSelect from 'slim-select'

// Connects to data-controller="slim-select"
export default class extends Controller {
  static targets = ["removeelement"]

  //[ 'property','characteristic','client' ]
  connect() {
    console.log( 'connect slimselect' );
    // console.log( 'this from slimselect', this )
    // console.log( 'this.element', this.element )
    const searchUrl = this.element.dataset.searchUrl;
    const nestedUrl = this.element.dataset.nestedUrl;
    const warehouseId = this.element.dataset.warehouseId;
    
    // console.log( 'searchUrl', nestedUrl );
    // console.log( 'nestedUrl', nestedUrl );

      this.slimselect = new SlimSelect({
        select: this.element,
        settings: {
          //minSelected: 1,
          //maxSelected: 1,
        },
        events: {
          search: (search, currentData) => {
            return new Promise((resolve, reject) => {
              if (search.length < 2) {
                return reject('Search must be at least 2 characters')
              }
              if (searchUrl != undefined ){
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
                    //console.log( 'data', data );
                    const options = data.map((d) => {
                      return {
                        text: `${d.title}`,
                        value: `${d.id}`,
                      }
                    })

                    resolve(options);
                  })
              }
            })
          },
          beforeChange: (newVal, oldVal) => {
            // console.log(newVal)
            //return false // this will stop the change from happening
          },
          afterChange: ( newVal ) => {
            if (nestedUrl != undefined ){
              var turboId = this.element.closest('turbo-frame').getAttribute('id');
              // var selectId = this.element.getAttribute('id')
              // console.log('selectId', selectId)
              // console.log('nestedUrl', nestedUrl)
              
              let params = new URLSearchParams()
              params.append("turboId", turboId)
              // if (warehouseId != undefined ){
              params.append("warehouse_id", warehouseId);
              // }
              // params.append("selectId", selectId)
              params.append("selected_id", newVal[0].value)
              
              get(`${nestedUrl}?${params}`, {  
                responseKind: "turbo-stream"
              })
            }
          }
        }

      })
  
    }

}




