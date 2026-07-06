(function () {
  var header = document.querySelector('.site-header');
  var toggle = document.querySelector('.nav-toggle');
  var mobile = document.querySelector('.nav-mobile');

  function setMenuOpen(open) {
    if (!toggle || !mobile) return;
    mobile.classList.toggle('open', open);
    toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    toggle.setAttribute('aria-label', open ? 'Close menu' : 'Open menu');
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
        notice.textContent =
          'Your email app should open with a pre-filled message to support@pinfoldai.com. ' +
          'If it did not open, email us directly at support@pinfoldai.com.';
        notice.hidden = false;
      }
    });
  }
})();
