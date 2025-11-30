import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]
  
  add(event) {
    event.preventDefault()
    
    // Clone le template
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    
    // Ajoute au conteneur
    this.containerTarget.insertAdjacentHTML('beforeend', content)
  }
  
  remove(event) {
    event.preventDefault()
    
    const item = event.target.closest('.nested-fields')
    
    // Si l'enregistrement existe déjà en DB, marque pour destruction
    const destroyInput = item.querySelector('input[name*="_destroy"]')
    if (destroyInput) {
      destroyInput.value = '1'
      item.style.display = 'none'
    } else {
      // Sinon, supprime simplement du DOM
      item.remove()
    }
  }
}