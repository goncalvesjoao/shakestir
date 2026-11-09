import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "results", "count", "status"]

  disconnect() {
    clearTimeout(this.timer)
    this.request?.abort()
  }

  search(event) {
    clearTimeout(this.timer)
    this.request?.abort()
    if (event.isComposing) return
    this.timer = setTimeout(() => this.apply(), 300)
  }

  submit(event) {
    event.preventDefault()
    this.apply()
  }

  async apply() {
    clearTimeout(this.timer)
    this.request?.abort()
    const request = new AbortController()
    this.request = request
    const url = new URL(this.formTarget.action)
    url.search = new URLSearchParams(new FormData(this.formTarget)).toString()
    this.resultsTarget.setAttribute("aria-busy", "true")
    this.statusTarget.textContent = "Searching…"
    try {
      const response = await fetch(url, { signal: request.signal, headers: { Accept: "text/html" } })
      if (!response.ok) throw new Error("Search failed")
      const page = new DOMParser().parseFromString(await response.text(), "text/html")
      const results = page.querySelector('[data-catalog-search-target="results"]')
      const count = page.querySelector('[data-catalog-search-target="count"]')
      if (!results || !count) throw new Error("Missing results")
      if (request.signal.aborted) return
      this.resultsTarget.replaceChildren(...results.childNodes)
      this.countTarget.textContent = count.textContent
      history.replaceState(history.state, "", url)
      this.statusTarget.textContent = ""
    } catch (error) {
      if (error.name !== "AbortError") {
        this.statusTarget.textContent = "Couldn’t update results. Type again or press Enter to retry."
      }
    } finally {
      if (this.request === request) this.resultsTarget.removeAttribute("aria-busy")
    }
  }
}
