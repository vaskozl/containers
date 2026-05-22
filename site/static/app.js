(function () {
  'use strict';

  var REGISTRY = 'ghcr.io/vaskozl/';

  var desktop = document.getElementById('desktop');
  var browser = document.getElementById('browser');
  var flatpak = document.getElementById('flatpak');
  var cmdEl = document.getElementById('bootc-cmd');
  var dlEl = document.getElementById('img-download');
  var metaEl = document.getElementById('img-meta');

  var manifest = null;

  function flavorName() {
    return desktop.value + '-' + browser.value + '-' + flatpak.value;
  }

  function fmtSize(bytes) {
    if (!bytes && bytes !== 0) return null;
    var mb = bytes / (1024 * 1024);
    if (mb >= 1024) return (mb / 1024).toFixed(2) + ' GB';
    return mb.toFixed(0) + ' MB';
  }

  function update() {
    var name = flavorName();
    cmdEl.textContent = 'bootc switch ' + REGISTRY + name;

    var entry = null;
    if (manifest && Array.isArray(manifest.flavors)) {
      for (var i = 0; i < manifest.flavors.length; i++) {
        if (manifest.flavors[i].name === name) { entry = manifest.flavors[i]; break; }
      }
    }

    if (entry && entry.img_oci) {
      // OCI artifact URL: link to the ghcr.io UI for the artifact; users pull with oras.
      dlEl.href = 'https://' + entry.img_oci.replace(/:.*$/, '');
      dlEl.removeAttribute('aria-disabled');
      var size = fmtSize(entry.size_bytes);
      metaEl.textContent = size ? ('Raw disk image · ' + size) : 'Raw disk image';
    } else {
      dlEl.href = '#';
      dlEl.setAttribute('aria-disabled', 'true');
      metaEl.textContent = 'Image artifact not yet published for this flavor';
    }
  }

  function bind() {
    desktop.addEventListener('change', update);
    browser.addEventListener('change', update);
    flatpak.addEventListener('change', update);
  }

  function loadManifest() {
    var urls = ['data/flavors-manifest.json', 'data/flavors-manifest.sample.json'];
    var tried = 0;
    function next() {
      if (tried >= urls.length) { update(); return; }
      var url = urls[tried++];
      fetch(url, { cache: 'no-cache' })
        .then(function (r) { if (!r.ok) throw new Error(r.status); return r.json(); })
        .then(function (j) { manifest = j; update(); })
        .catch(next);
    }
    next();
  }

  function renderTable(data) {
    var body = document.getElementById('compare-body');
    var meta = document.getElementById('compare-meta');
    if (!data || !Array.isArray(data.images) || data.images.length === 0) {
      body.innerHTML = '<tr><td colspan="8" class="text-muted-foreground">Comparison data not yet generated.</td></tr>';
      return;
    }
    var rows = data.images.map(function (img) {
      var c = img.cve || {};
      function td(v, cls) { return '<td class="' + (cls || '') + '">' + (v == null ? '—' : v) + '</td>'; }
      return '<tr>' +
        td(img.name) +
        td(img.size_mb, 'text-right') +
        td(img.layers,  'text-right') +
        td(c.critical,  'text-right') +
        td(c.high,      'text-right') +
        td(c.medium,    'text-right') +
        td(c.low,       'text-right') +
        td(c.total,     'text-right font-medium') +
        '</tr>';
    });
    body.innerHTML = rows.join('');
    if (data.generated_at) {
      meta.textContent = 'Generated ' + data.generated_at + (data.grype_db_built ? ' · grype DB ' + data.grype_db_built : '');
    }
  }

  function loadComparison() {
    var urls = ['data/cve-comparison.json', 'data/cve-comparison.sample.json'];
    var tried = 0;
    function next() {
      if (tried >= urls.length) {
        renderTable(null);
        return;
      }
      var url = urls[tried++];
      fetch(url, { cache: 'no-cache' })
        .then(function (r) { if (!r.ok) throw new Error(r.status); return r.json(); })
        .then(renderTable)
        .catch(next);
    }
    next();
  }

  bind();
  loadManifest();
  loadComparison();
})();
