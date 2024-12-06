import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.loadTheme()
  }

  loadTheme() {
    try {
      const theme = JSON.parse(localStorage.getItem("__NEXUS__HTML__ADMIN__LAYOUT__"))?.theme || "light"
      document.documentElement.setAttribute("data-theme", theme)
    } catch (e) {
      document.documentElement.setAttribute("data-theme", "light")
    }
  }

  toggle() {
    const currentTheme = document.documentElement.getAttribute("data-theme")
    const newTheme = currentTheme === "dark" ? "light" : "dark"
    document.documentElement.setAttribute("data-theme", newTheme)
    localStorage.setItem("__NEXUS__HTML__ADMIN__LAYOUT__", JSON.stringify({ theme: newTheme }))
  }
}
