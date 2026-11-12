// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

class App {
  constructor() {
    console.log("App initialized");
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
