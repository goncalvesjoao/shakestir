// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

class App {
  constructor() {
    const savedTheme = localStorage.getItem("theme");

    if (savedTheme) {
      document.documentElement.setAttribute("data-theme", savedTheme);
    }
  }

  toggleTheme(_element) {
    const html = document.documentElement;
    const currentTheme = html.getAttribute("data-theme");

    if (currentTheme === "light") {
      localStorage.setItem("theme", "dark");
      html.setAttribute("data-theme", "dark");
    } else if (currentTheme === "dark") {
      localStorage.removeItem("theme");
      html.removeAttribute("data-theme");
    } else {
      localStorage.setItem("theme", "light");
      html.setAttribute("data-theme", "light");
    }
  }

  goBack(element) {
    if (element) {
      const parentDialog = element.closest("dialog");

      if (parentDialog) {
        parentDialog.close();

        return false;
      }
    }

    if (window.history.length > 1) {
      window.history.back();
    } else {
      window.location.href = '/';
    }

    return false;
  }
}

window.app = new App();
