import { Application } from "@hotwired/stimulus"

// Import your search controller here:
import SearchController from "./search_controller"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// Register the controller under the name "search" (this matches data-controller="search")
application.register("search", SearchController)

export { application }
