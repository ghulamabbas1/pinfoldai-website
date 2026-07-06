(function () {
  var LANG_KEY = 'pinfold-lang';
  var THEME_KEY = 'pinfold-theme';
  var SUPPORTED_LANGS = ['en', 'ar', 'fr', 'zh'];

  function getLang() {
    var stored = localStorage.getItem(LANG_KEY) || 'en';
    return SUPPORTED_LANGS.indexOf(stored) >= 0 ? stored : 'en';
  }

  function getTheme() {
    return localStorage.getItem(THEME_KEY) === 'dark' ? 'dark' : 'light';
  }

  function dict(lang) {
    var all = window.PINFOLD_I18N || {};
    return all[lang] || all.en || {};
  }

  function t(key, lang) {
    var d = dict(lang || getLang());
    return d[key] !== undefined ? d[key] : key;
  }

  function applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem(THEME_KEY, theme);
    var meta = document.querySelector('meta[name="theme-color"]');
    if (meta) {
      meta.setAttribute('content', theme === 'dark' ? '#07080d' : '#f8fafc');
    }
    var toggle = document.getElementById('theme-toggle');
    if (toggle) {
      toggle.setAttribute(
        'aria-label',
        t(theme === 'dark' ? 'theme.switchToLight' : 'theme.switchToDark')
      );
    }
  }

  function applyI18n(lang) {
    var d = dict(lang);
    document.documentElement.lang = lang;
    document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
    localStorage.setItem(LANG_KEY, lang);

    document.querySelectorAll('[data-i18n]').forEach(function (el) {
      var key = el.getAttribute('data-i18n');
      if (d[key] !== undefined) {
        el.textContent = d[key];
      }
    });

    document.querySelectorAll('[data-i18n-html]').forEach(function (el) {
      var key = el.getAttribute('data-i18n-html');
      if (d[key] !== undefined) {
        el.innerHTML = d[key];
      }
    });

    document.querySelectorAll('[data-i18n-placeholder]').forEach(function (el) {
      var key = el.getAttribute('data-i18n-placeholder');
      if (d[key] !== undefined) {
        el.placeholder = d[key];
      }
    });

    var page = document.body.getAttribute('data-page');
    if (page) {
      var titleKey = 'meta.' + page + '.title';
      var descKey = 'meta.' + page + '.description';
      if (d[titleKey]) document.title = d[titleKey];
      var desc = document.querySelector('meta[name="description"]');
      if (desc && d[descKey]) desc.setAttribute('content', d[descKey]);
    }

    var langSelect = document.getElementById('lang-select');
    if (langSelect) langSelect.value = lang;

    applyTheme(getTheme());
  }

  function wireHeaderControls() {
    var langSelect = document.getElementById('lang-select');
    var themeToggle = document.getElementById('theme-toggle');
    if (!langSelect || !themeToggle) return;
    if (langSelect.dataset.wired === '1') return;
    langSelect.dataset.wired = '1';
    themeToggle.dataset.wired = '1';

    langSelect.addEventListener('change', function (e) {
      applyI18n(e.target.value);
    });

    themeToggle.addEventListener('click', function () {
      var next = getTheme() === 'dark' ? 'light' : 'dark';
      applyTheme(next);
    });
  }

  var header = document.querySelector('.site-header');
  var toggle = document.querySelector('.nav-toggle');
  var mobile = document.querySelector('.nav-mobile');

  function setMenuOpen(open) {
    if (!toggle || !mobile) return;
    mobile.classList.toggle('open', open);
    toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    var closeKey = 'nav.closeMenu';
    var openKey = 'nav.openMenu';
    var d = dict(getLang());
    toggle.setAttribute(
      'aria-label',
      open ? (d[closeKey] || 'Close menu') : (d[openKey] || d['nav.menu'] || 'Menu')
    );
    document.body.style.overflow = open ? 'hidden' : '';
  }

  if (toggle && mobile) {
    toggle.addEventListener('click', function () {
      setMenuOpen(!mobile.classList.contains('open'));
    });

    mobile.querySelectorAll('a').forEach(function (link) {
      link.addEventListener('click', function () {
        setMenuOpen(false);
      });
    });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') setMenuOpen(false);
    });
  }

  if (header) {
    var onScroll = function () {
      header.classList.toggle('scrolled', window.scrollY > 8);
    };
    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
  }

  var path = window.location.pathname.replace(/\/$/, '') || '/';
  document.querySelectorAll('[data-nav]').forEach(function (link) {
    var href = link.getAttribute('href').replace(/\/$/, '') || '/';
    if (path === href || (href !== '/' && path.startsWith(href))) {
      link.classList.add('active');
    }
  });

  if ('IntersectionObserver' in window) {
    var reveals = document.querySelectorAll('.reveal');
    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add('visible');
            observer.unobserve(entry.target);
          }
        });
      },
      { rootMargin: '0px 0px -8% 0px', threshold: 0.08 }
    );
    reveals.forEach(function (el) {
      observer.observe(el);
    });
  } else {
    document.querySelectorAll('.reveal').forEach(function (el) {
      el.classList.add('visible');
    });
  }

  var form = document.getElementById('contact-form');
  if (form) {
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var category = form.category.value;
      var name = form.name.value.trim();
      var email = form.email.value.trim();
      var subject = form.subject.value.trim() || 'Pinfold website inquiry';
      var body = form.message.value.trim();
      var fullSubject = '[' + category + '] ' + subject;
      var fullBody =
        'Name: ' + name + '\n' +
        'Email: ' + email + '\n' +
        'Category: ' + category + '\n\n' +
        body;
      var mailto =
        'mailto:support@pinfoldai.com' +
        '?subject=' + encodeURIComponent(fullSubject) +
        '&body=' + encodeURIComponent(fullBody);
      window.location.href = mailto;
      var notice = document.getElementById('form-notice');
      if (notice) {
        notice.textContent = t('contact.form.notice');
        notice.hidden = false;
      }
    });
  }

  wireHeaderControls();
  applyI18n(getLang());
})();
