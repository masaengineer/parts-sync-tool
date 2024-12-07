// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import "./nexus"

import 'iconify-icon';
import SimpleBar from 'simplebar';
import 'simplebar/dist/simplebar.css';

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('[data-simplebar]').forEach((el) => {
    new SimpleBar(el);
  });
});
