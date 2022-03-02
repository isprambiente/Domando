import { Controller } from "@hotwired/stimulus";
import Swal from 'sweetalert2';

export default class extends Controller {

  connect() {
    var body;
    body = this.element.innerHTML;
    if (body) {
      this.send(body);
    }
    return this.element.outerHTML = '';
  }

  disconnect() {
    return this.outerHTML = '';
  }

  send(body = '') {
    var options, position, width;
    width = this.element.dataset.modalSize || '90%';
    position = this.element.dataset.modalPosition || 'top';
    options = {
      width: width,
      heightAuto: true,
      height: true,
      toast: false,
      icon: false,
      timerProgressBar: false,
      position: position,
      title: false,
      html: body,
      footer: false,
      timer: false,
      showConfirmButton: false,
      showCloseButton: true,
      showCancelButton: false,
      cancelButtonText: "<%= I18n.t( 'close' ) %>",
      showClass: {
        popup: 'animated fadeIn'
      },
      hideClass: {
        popup: ''
      }
    };
    if (Swal.isVisible()) {
      Swal.update(options);
    } else {
      Swal.fire(options);
    }
    if (Swal.getPopup().querySelector('.is-formula')) {
      return MathJax.typeset();
    }
  }
}
