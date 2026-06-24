import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "trackTitle", "albumTitle", "albumAuthor", "playlist", "trackCounter"]
  static values = { songs: Array, shuffle: Boolean }

  connect() {
    this.buildOrder()
    this.position = 0
    this.loadSong(this.order[0])
  }

  // Construit l'ordre de lecture : aléatoire (radio) ou séquentiel (album)
  buildOrder() {
    this.order = [...this.songsValue.keys()]
    if (this.shuffleValue) {
      for (let i = this.order.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1))
        ;[this.order[i], this.order[j]] = [this.order[j], this.order[i]]
      }
    }
  }

  loadSong(index) {
    if (this.songsValue[index] === undefined) return

    this.currentIndex = index
    const song = this.songsValue[index]

    this.audioTarget.src = song.audio_url
    this.trackTitleTarget.textContent = song.title

    if (this.hasAlbumTitleTarget) {
      if (song.album_name) {
        this.albumTitleTarget.textContent = `Album : ${song.album_name}`
        this.albumTitleTarget.href = song.album_web_link || '#'
      } else {
        this.albumTitleTarget.textContent = 'Album : non renseigné'
        this.albumTitleTarget.href = '#'
      }
    }

    if (this.hasAlbumAuthorTarget) {
      this.albumAuthorTarget.textContent = song.album_author ? song.album_author : 'Artiste(s) non renseigné(s)'
    }

    this.audioTarget.load()

    if (this.hasPlaylistTarget) {
      this.playlistTarget.querySelectorAll('li').forEach((li, i) => {
        li.style.fontWeight = i === index ? 'bold' : 'normal'
      })
    }

    if (this.hasTrackCounterTarget) {
      this.trackCounterTarget.textContent = `Morceau n°${this.position + 1}/${this.songsValue.length}`
    }
  }

  playSong(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    const pos = this.order.indexOf(index)
    if (pos !== -1) this.position = pos
    this.loadSong(index)
    this.audioTarget.play()
  }

  next() {
    this.position++
    // File épuisée : tous les morceaux ont été joués une fois → nouvel ordre
    if (this.position >= this.order.length) {
      const last = this.currentIndex
      this.buildOrder()
      // évite de rejouer le même morceau pile à la jonction
      if (this.shuffleValue && this.order.length > 1 && this.order[0] === last) {
        ;[this.order[0], this.order[1]] = [this.order[1], this.order[0]]
      }
      this.position = 0
    }
    this.loadSong(this.order[this.position])
    this.audioTarget.play()
  }

  previous() {
    this.position = this.position === 0 ? this.order.length - 1 : this.position - 1
    this.loadSong(this.order[this.position])
    this.audioTarget.play()
  }
}