(function () {
  var toggle = document.querySelector('.nav-toggle');
  var mobile = document.querySelector('.nav-mobile');
  if (toggle && mobile) {
    toggle.addEventListener('click', function () {
      mobile.classList.toggle('open');
    });
  }

  var path = window.location.pathname.replace(/\/$/, '') || '/';
  document.querySelectorAll('[data-nav]').forEach(function (link) {
    var href = link.getAttribute('href').replace(/\/$/, '') || '/';
    if (path === href || (href !== '/' && path.startsWith(href))) {
      link.classList.add('active');
    }
  });

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
