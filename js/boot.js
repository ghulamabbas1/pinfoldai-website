(function () {
  var theme = localStorage.getItem('pinfold-theme');
  if (theme === 'dark') {
    document.documentElement.setAttribute('data-theme', 'dark');
  } else {
    document.documentElement.setAttribute('data-theme', 'light');
  }
  var lang = localStorage.getItem('pinfold-lang') || 'en';
  document.documentElement.lang = lang;
  if (lang === 'ar') {
    document.documentElement.dir = 'rtl';
  }
})();
