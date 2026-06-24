import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "pagination"]

  search() {
    const query = this.inputTarget.value.trim()

    if (query === "") {
      this.reset()
      return
    }

    fetch(`/songs/search?q=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(songs => this.displayResults(songs))
  }

  handleKeydown(event) {
    if (event.key === "Enter") {
      this.search()
    }
  }

  displayResults(songs) {
    // Cache la pagination pendant la recherche
    if (this.hasPaginationTarget) {
      this.paginationTarget.style.display = "none"
    }

    if (songs.length === 0) {
      this.resultsTarget.innerHTML = `
        <tr>
          <td colspan="2" class="px-6 py-4 text-gray-500 italic">Aucun résultat trouvé.</td>
        </tr>
      `
      return
    }

    this.resultsTarget.innerHTML = songs.map(song => `
      <tr class="hover:bg-purple-50 transition">
        <td class="px-6 py-4">
          <a href="/songs/${song.id}" class="text-purple-600 hover:text-purple-800 font-medium">${song.title}</a>
        </td>
        <td class="px-6 py-4">
          <a href="/songs/${song.id}" class="text-purple-600 hover:text-purple-800 text-sm">Voir</a>
        </td>
      </tr>
    `).join("")
  }

  reset() {
    // Recharge la page pour retrouver la liste paginée
    window.location.href = window.location.pathname
  }
}