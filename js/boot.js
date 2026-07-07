(function () {
  var theme = localStorage.getItem('pinfold-theme');
  document.documentElement.setAttribute('data-theme', theme === 'dark' ? 'dark' : 'light');
  var lang = localStorage.getItem('pinfold-lang') || 'en';
  document.documentElement.lang = lang;
  document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
})();
