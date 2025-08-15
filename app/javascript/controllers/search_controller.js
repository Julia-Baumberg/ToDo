import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
static targets = ["title", "description", "task"]

connect() {
  this.filterTasks = this.debounce(this.filterTasks.bind(this), 300)
}

  filterTasks(event) {
    const searchTerm = event.target.value.toLowerCase()
    const cards = document.querySelectorAll(".card")

    cards.forEach((card) => {
      const postDescription = card.querySelector('#description').textContent.toLowerCase();
      const postTitle = card.querySelector('#title').textContent.toLowerCase();
      if (postDescription.includes(searchTerm) || postTitle.includes(searchTerm)) {
        card.classList.remove("d-none");
      } else {
        card.classList.add("d-none");
      }
    });
  }

  debounce(func, delay) {
    let timeoutId
    return (...args) => {
      clearTimeout(timeoutId)
      timeoutId = setTimeout(() => func(...args), delay)
    }
  }
}
