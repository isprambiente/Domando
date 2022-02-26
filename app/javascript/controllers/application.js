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

// Configure Stimulus development experience
application.warning = true
application.debug   = true
window.Stimulus     = application

export { application }
