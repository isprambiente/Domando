import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import * as ActiveStorage from '@rails/activestorage'
import SlimSelect from 'slim-select'

const application = Application.start()
ActiveStorage.start()

document.addEventListener('trix-file-accept', function(event) { event.preventDefault(); });
document.querySelectorAll('[disabled]').forEach(function(obj) {
  return obj.classList.add('is-disabled');
});
window.addEventListener("click",function(t){if("click->menu#open"!=t.target.getAttribute("data-action")&&"click->section#colShow"!=t.target.getAttribute("data-action")){const e=document.querySelector("#cart_col.quickview"),c=document.querySelector("#filters_col.quickview"),mm=document.querySelector("#menu_col.quickview");null==mm||mm.contains(t.target)||mm.classList.remove("is-active"),null==e||e.contains(t.target)||e.classList.remove("is-active"),null==c||c.contains(t.target)||c.classList.remove("is-active")}t.stopPropagation()});

window.addEventListener("turbo:load", function(t){
  var _paq = window._paq = window._paq || [];
  _paq.push(['trackPageView']);
  _paq.push(['enableLinkTracking']);
  (function() {
    var u="https://matomo.isprambiente.it/";
    _paq.push(['setTrackerUrl', u+'matomo.php']);
    _paq.push(['setSiteId', '11']);
    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
    g.async=true; g.src=u+'matomo.js'; s.parentNode.insertBefore(g,s);
  })();
  t.stopPropagation();
});

// Configure Stimulus development experience
application.warning = false
application.debug   = false
window.Stimulus     = application

export { application }
