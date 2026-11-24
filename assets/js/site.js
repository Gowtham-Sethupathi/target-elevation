/* TARGET ELEVATION — shared header behaviour (mobile menu + scroll shadow) */
(function () {
  var hd = document.getElementById('te-hd');
  if (!hd) return;
  var tog = hd.querySelector('.te-hd-tog');
  var nav = document.getElementById('te-hd-nav');

  function setOpen(open) {
    hd.classList.toggle('is-open', open);
    tog.setAttribute('aria-expanded', open ? 'true' : 'false');
    tog.setAttribute('aria-label', open ? 'Close menu' : 'Open menu');
  }
  tog.addEventListener('click', function () { setOpen(!hd.classList.contains('is-open')); });
  nav.addEventListener('click', function (e) { if (e.target.closest('a')) setOpen(false); });
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && hd.classList.contains('is-open')) { setOpen(false); tog.focus(); }
  });
  document.addEventListener('click', function (e) {
    if (hd.classList.contains('is-open') && !hd.contains(e.target)) setOpen(false);
  });
  window.matchMedia('(min-width: 961px)').addEventListener('change', function (m) { if (m.matches) setOpen(false); });

  var onScroll = function () { hd.classList.toggle('is-scrolled', window.scrollY > 8); };
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
})();
