(function () {
  var themes = ['light', 'medium', 'dark'];

  function setTheme(theme) {
    document.documentElement.dataset.theme = theme;
    localStorage.setItem('theme', theme);
  }

  function cycleTheme() {
    var current = document.documentElement.dataset.theme || 'dark';
    var next = themes[(themes.indexOf(current) + 1) % themes.length];
    setTheme(next);
  }

  // dark is the default when nothing is stored
  setTheme(localStorage.getItem('theme') || 'dark');
  window.cycleTheme = cycleTheme;
})();
