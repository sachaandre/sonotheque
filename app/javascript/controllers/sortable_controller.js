import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]
  
  connect() {
    this.updateDragHandlers()
  }
  
  updateDragHandlers() {
    this.itemTargets.forEach((item, index) => {
      item.draggable = true
      item.dataset.index = index
    })
  }
  
    dragStart(event) {
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setData("text/html", event.currentTarget.innerHTML)
    this.draggedItem = event.currentTarget
    
    // Ajoute une classe pour indiquer qu'on drag
    event.currentTarget.style.opacity = "0.5"
    }
  
  dragOver(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
    
    const target = event.currentTarget
    if (target !== this.draggedItem) {
      const boundingRect = target.getBoundingClientRect()
      const offset = boundingRect.y + (boundingRect.height / 2)
      
      if (event.clientY - offset > 0) {
        target.after(this.draggedItem)
      } else {
        target.before(this.draggedItem)
      }
    }
  }
  
    dragEnd(event) {
    event.currentTarget.style.opacity = "1"
    this.updateTrackNumbers()
    }
    
  updateTrackNumbers() {
    const trackInputs = this.element.querySelectorAll('input[name*="track_number"]')
    trackInputs.forEach((input, index) => {
      input.value = index + 1
    })
  }
}