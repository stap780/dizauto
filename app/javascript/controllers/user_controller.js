import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user"
export default class extends Controller {
  static targets = ['role', 'permissionModel', 'nested']
  static classes = [ "dnone" ]

  connect() {
    //console.log('user js controller');
  }

  change_role(e) {
    console.log('user change_role event => ', e); 
    //console.log(this.roleTarget.value);
    if (this.roleTarget.value != 'admin') {
      console.log('user change_role and role not admin'); 
      this.nestedTarget.classList.remove(this.dnoneClass);
    }
    if (this.roleTarget.value == 'admin') {
        console.log('user change_role and role not admin'); 
        this.nestedTarget.classList.add(this.dnoneClass);
    }
  }

  change_permission_model(e) {
    console.log('user change_permission_model event => ', e); 
    //console.log(this.roleTarget.value);
    if (this.permissionModelTarget.value != 0) {
      console.log('user change_permission_model');  
      //this.attributesTarget.classList.add(this.dnoneClass);
      }
  }


}
