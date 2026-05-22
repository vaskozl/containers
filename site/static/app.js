(function () {
  'use strict';

  var REGISTRY = 'ghcr.io/vaskozl/';

  var desktop = document.getElementById('desktop');
  var browser = document.getElementById('browser');
  var flatpak = document.getElementById('flatpak');
  var bootcEl = document.getElementById('bootc-cmd');
  var podmanEl = document.getElementById('podman-cmd');
  var installEl = document.getElementById('install-cmd');

  function flavorName() {
    return desktop.value + '-' + browser.value + '-' + flatpak.value;
  }

  function update() {
    var ref = REGISTRY + flavorName() + ':latest';
    bootcEl.textContent = 'bootc switch ' + ref;
    podmanEl.textContent = 'podman run --rm -it ' + ref + ' /bin/bash';
    installEl.textContent =
      'podman run --rm --privileged --pid=host -v /dev:/dev -v /:/target \\\n' +
      '  ' + ref + ' \\\n' +
      '  bootc install to-disk /dev/sdX';
  }

  desktop.addEventListener('change', update);
  browser.addEventListener('change', update);
  flatpak.addEventListener('change', update);

  function renderTable(data) {
    var body = document.getElementById('compare-body');
    var meta = document.getElementById('compare-meta');
    if (!data || !Array.isArray(data.images) || data.images.length === 0) {
      body.replaceChildren();
      var tr = document.createElement('tr');
      var td = document.createElement('td');
      td.colSpan = 8;
      td.className = 'text-muted-foreground';
      td.textContent = 'Comparison data not yet generated.';
      tr.appendChild(td);
      body.appendChild(tr);
      return;
    }
    body.replaceChildren();
    data.images.forEach(function (img) {
      var c = img.cve || {};
      var tr = document.createElement('tr');
      function td(v, cls) {
        var el = document.createElement('td');
        if (cls) el.className = cls;
        el.textContent = (v == null ? '—' : String(v));
        tr.appendChild(el);
      }
      td(img.name);
      td(img.size_mb, 'text-right');
      td(img.layers,  'text-right');
      td(c.critical,  'text-right');
      td(c.high,      'text-right');
      td(c.medium,    'text-right');
      td(c.low,       'text-right');
      td(c.total,     'text-right font-medium');
      body.appendChild(tr);
    });
    if (data.generated_at) {
      meta.textContent = 'Generated ' + data.generated_at + (data.grype_db_built ? ' · grype DB ' + data.grype_db_built : '');
    }
  }

  function loadComparison() {
    var urls = ['data/cve-comparison.json', 'data/cve-comparison.sample.json'];
    var tried = 0;
    function next() {
      if (tried >= urls.length) { renderTable(null); return; }
      var url = urls[tried++];
      fetch(url, { cache: 'no-cache' })
        .then(function (r) { if (!r.ok) throw new Error(r.status); return r.json(); })
        .then(renderTable)
        .catch(next);
    }
    next();
  }

  update();
  loadComparison();
})();
