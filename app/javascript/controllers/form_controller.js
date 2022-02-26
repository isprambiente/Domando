import { Controller } from "@hotwired/stimulus";
import Rails from '@rails/ujs';
import Timeout from 'smart-timeout';
import SlimSelect from 'slim-select';
import Swal from 'sweetalert2';

export default class extends Controller {
  connect() {
    // Per disattivare l'evento click dei bottoni dopo il passaggio a Bulma
    // che non ha la gestione eventi via Javascript
    document.querySelectorAll('[disabled]').forEach(function(obj) {
      return obj.classList.add('is-disabled');
    });
    if (this.hasSlimselectTarget) {
      return this.slimselectTargets.forEach(function(slim) {
        return this.slimSelect(slim);
      });
    }
  }

  send(event) {
    return Rails.fire(event.target.closest('form'), 'submit');
  }

  delayedSend(event) {
    if (Timeout.exists('textDelay')) {
      Timeout.set('textDelay', true);
    }
    return Timeout.set('textDelay', (function() {
      return this.send(event);
    }), 750);
  }

  reset(event) {
    return Rails.fire(event.target.closest('form'), 'reset');
  }

  close(event) {
    return Swal.close();
  }

  toggleTagActive(event) {
    var tags, tags_container;
    tags_container = event.target.closest('.field');
    tags = tags_container.querySelectorAll('.tag');
    tags.forEach(function(tag) {
      if (event.target.dataset.type !== 'reset') {
        return tag.classList.remove('is-info');
      }
    });
    if (event.target.dataset.type !== 'reset') {
      event.target.closest('.tag').classList.add('is-info');
      if (tags[tags.length - 1].dataset.type === 'reset') {
        return tags[tags.length - 1].classList.remove('is-hidden');
      }
    }
  }

  desactiveTagFilter(event) {
    var tags, tags_container;
    tags_container = event.target.closest('.field');
    tags = tags_container.querySelectorAll('.tag');
    tags.forEach(function(tag) {
      return tag.classList.remove('is-info');
    });
    if (tags[tags.length - 1].dataset.type === 'reset') {
      return tags[tags.length - 1].classList.add('is-hidden');
    }
  }

  toggleVisible(event) {
    document.getElementById(event.currentTarget.dataset.id).classList.toggle('is-hidden');
    if (event.currentTarget.querySelector('i.fas')) {
      return event.currentTarget.querySelector('i.fas').classList.toggle('fa-chevron-down');
    }
  }

  slimSelect(select) {
    if (select.dataset.formAddable === 'true') {
      return new SlimSelect({
        addToBody: true,
        select: `#${select.id}`,
        searchingText: 'Ricerca in corso...',
        searchText: 'Nessun record trovato',
        searchPlaceholder: 'Cerca',
        placeholder: 'Seleziona uno o più valori',
        text: 'Seleziona uno o più valori',
        closeOnSelect: select.dataset.formCloseonselect === 'true' ? true : false,
        addable: function(value) {
          var displayData;
          displayData = [];
          if (value === '') {
            return this.send('Inserire un valore prima di cliccare sul bottone', 'error');
          } else {
            return value;
          }
        }
      });
    } else {
      return new SlimSelect({
        addToBody: true,
        select: `#${select.id}`,
        searchingText: 'Ricerca in corso...',
        searchText: 'Nessun record trovato',
        searchPlaceholder: 'Cerca',
        placeholder: 'Seleziona uno o più valori',
        text: 'Seleziona uno o più valori'
      });
    }
  }

}