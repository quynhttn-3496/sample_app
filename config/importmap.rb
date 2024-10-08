# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "i18n-js", to: "https://ga.jspm.io/npm:i18n-js@3.9.2/app/assets/javascripts/i18n.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/custom",      under: "custom"
pin_all_from "app/javascript/i18n", under: "i18n"
