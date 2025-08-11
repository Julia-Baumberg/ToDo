import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
static targets = ["title", "description", "task"]

  connect() {
    console.log("I'm working")
  }

  filterTasks(event) {
    const searchTerm = event.target.value.toLowerCase()

    this.titleTargets.forEach((title) => {
      const postDescription = title.nextElementSibling.textContent.toLowerCase();
      const postTitle = title.textContent.toLowerCase();
      if (postDescription.includes(searchTerm) || postTitle.includes(searchTerm)) {
        title.parentElement.style.display = "";
      } else {
        title.parentElement.style.display = "none";
      }

    });
  }
}
