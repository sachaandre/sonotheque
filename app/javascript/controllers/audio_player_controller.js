import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "trackTitle", "playlist"]
  static values = { songs: Array }
  
  connect() {
    this.currentIndex = 0
    this.loadSong(0)
  }
  
  loadSong(index) {
    if (!this.songsValue[index]) return
    
    this.currentIndex = index
    const song = this.songsValue[index]
    
    this.audioTarget.src = song.audio_url
    this.trackTitleTarget.textContent = song.title
    this.trackTitleTarget.href = song.album_web_link || '#'
    this.audioTarget.load()
    
    // Highlight dans la playlist
    this.playlistTarget.querySelectorAll('li').forEach((li, i) => {
      li.style.fontWeight = i === index ? 'bold' : 'normal'
    })
  }
  
  playSong(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    this.loadSong(index)
    this.audioTarget.play()
  }
  
  next() {
    const nextIndex = (this.currentIndex + 1) % this.songsValue.length
    this.loadSong(nextIndex)
    this.audioTarget.play()
  }
  
  previous() {
    const prevIndex = this.currentIndex === 0 ? this.songsValue.length - 1 : this.currentIndex - 1
    this.loadSong(prevIndex)
    this.audioTarget.play()
  }
}