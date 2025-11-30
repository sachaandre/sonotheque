import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "searchInput", "results", "selectedList"]
  
  openModal(event) {
    event.preventDefault()
    this.modalTarget.style.display = "block"
    this.searchInputTarget.focus()
  }
  
  closeModal() {
    this.modalTarget.style.display = "none"
    this.searchInputTarget.value = ""
    this.resultsTarget.innerHTML = ""
  }
  
  async search() {
    const query = this.searchInputTarget.value
    const response = await fetch(`/songs/search?q=${encodeURIComponent(query)}`)
    const songs = await response.json()
    
    this.resultsTarget.innerHTML = songs.map(song => `
      <div class="song-result" data-song-id="${song.id}" data-song-title="${song.title}" data-action="click->song-picker#selectSong">
        ${song.title}
      </div>
    `).join('')
  }
  
  selectSong(event) {
    const songId = event.currentTarget.dataset.songId
    const songTitle = event.currentTarget.dataset.songTitle
    
    // Ajoute la chanson à la liste
    this.addSongToForm(songId, songTitle)
    
    // Ferme la modale
    this.closeModal()
  }
  
    addSongToForm(songId, songTitle) {
        // Récupère le contrôleur nested-form
        const nestedFormController = this.application.getControllerForElementAndIdentifier(
            document.querySelector('[data-controller*="nested-form"]'),
            "nested-form"
        )
        
        // Ajoute une nouvelle ligne via le contrôleur nested-form
        const event = new Event('click', { bubbles: true })
        nestedFormController.add(event)
        
        // Trouve la ligne qui vient d'être ajoutée et remplit le song_id
        const container = nestedFormController.containerTarget
        const lastField = container.querySelector('.nested-fields:last-child')
        const songIdInput = lastField.querySelector('input[name*="song_id"]')
        if (songIdInput) {
            songIdInput.value = songId
        }

         // Ajoute le titre à afficher
        const titleDisplay = lastField.querySelector('[data-song-title-display]')
        if (titleDisplay) {
            titleDisplay.textContent = songTitle
        }
        lastField.dataset.songTitle = songTitle
        
        // Met à jour le numéro de piste automatiquement
        const trackFields = container.querySelectorAll('input[name*="track_number"]')
        trackFields.forEach((field, index) => {
            field.value = index + 1
        })
    }
}