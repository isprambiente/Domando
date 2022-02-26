import { Controller } from "@hotwired/stimulus";
import Swal from 'sweetalert2';

export default class extends Controller {

  connect() {
    if (this.hasTextTarget) {
      this.send(this.textTarget.innerHTML, this.element.dataset.messageStatus || 'success');
      this.element.outerHTML = '';
    }
  }

  disconnect() {
    this.outerHTML = '';
  }

  send(message, level = 'success', timeout = 2000, toast = true) {
    var options;
    options = {
      toast: level === 'error' ? false : toast,
      icon: level,
      timerProgressBar: true,
      position: level === 'error' ? 'center' : 'top-end',
      text: message,
      timer: level === 'error' ? false : timeout,
      showConfirmButton: level === 'error' ? true : false,
      didOpen: (toast) => {
        toast.addEventListener('mouseenter', Swal.stopTimer);
        return toast.addEventListener('mouseleave', Swal.resumeTimer);
      },
      showClass: {
        popup: level === 'error' ? '' : 'animate__animated animate__bounceInRight'
      },
      hideClass: {
        popup: level === 'error' ? '' : 'animate__animated animate__bounceOutRight'
      }
    };
    return Swal.fire(options);
  }
}