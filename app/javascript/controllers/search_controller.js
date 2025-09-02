import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

connect() {
  this.filterTasks = this.debounce(this.filterTasks.bind(this), 300)
}

filterTasks(event) {
  const searchTerm = event.target.value.toLowerCase()
  const cards = this.element.querySelectorAll(".card")

  cards.forEach((card) => {
    const descriptionElement = card.querySelector(".description")
    const titleElement = card.querySelector(".title")

    const postDescription = (descriptionElement?.textContent || "").toLowerCase()
    const postTitle = (titleElement?.textContent || "").toLowerCase()

    const matchesSearch = postDescription.includes(searchTerm) || postTitle.includes(searchTerm)
    card.classList.toggle("d-none", !matchesSearch)
  })

  const hasAnyVisible = this.element.querySelectorAll(".card:not(.d-none)").length > 0

  const noResults = this.element.querySelector("#no-results")
  if (noResults) {
    noResults.classList.toggle("d-none", hasAnyVisible)
  }

  const results = this.element.querySelector("#results")
  const hideHeaders = !hasAnyVisible

  if (results) {
    results.classList.toggle("d-none", hideHeaders)
  }
}

  debounce(func, delay) {
    let timeoutId
    return (...args) => {
      clearTimeout(timeoutId)
      timeoutId = setTimeout(() => func(...args), delay)
    }
  }
}
