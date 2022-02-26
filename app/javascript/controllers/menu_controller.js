import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  open(event) {
    var menu, menuId;
    menuId = event.target.dataset.menuId;
    console.log(menuId);
    if (menuId) {
      menu = document.getElementById(menuId);
      if (menu) {
        return menu.classList.toggle('is-active');
      }
    }
  }

  close(event) {
    var menu, menuId;
    menuId = event.target.dataset.menuId;
    if (menuId) {
      menu = document.getElementById(menuId);
      if (menu) {
        return menu.classList.remove('is-active');
      }
    }
  }

  focus(event) {
    var target;
    if (event.currentTarget.dataset.menuId) {
      target = document.getElementById(event.currentTarget.dataset.menuId);
      if (target) {
        return target.scrollIntoView();
      }
    }
  }
}
