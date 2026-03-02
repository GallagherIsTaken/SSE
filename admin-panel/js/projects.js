import { db, storage } from './firebase-config.js';
import {
  collection, doc, setDoc, deleteDoc, onSnapshot, orderBy, query
} from 'https://www.gstatic.com/firebasejs/10.14.1/firebase-firestore.js';
import { ref, uploadBytes, getDownloadURL } from 'https://www.gstatic.com/firebasejs/10.14.1/firebase-storage.js';
import { showToast } from './ui-helpers.js';

const COL = 'projects';
let _projects = [];
let _editingId = null;

// State for complex sub-lists
let _featuresList = [];   // [{name, imageUrl}]
let _nearbyList = [];     // [{id, name, category, distance, distanceUnit}]
let _unitTypesList = [];  // [{id, name, price, landArea, buildingArea, bedrooms, bathrooms, floors}]
let _galleryList = [];    // [string URL]

const POI_CATEGORIES = ['Pusat Perbelanjaan', 'Pendidikan', 'Kesehatan', 'Transportasi', 'Olahraga', 'Hiburan', 'Restoran', 'Lainnya'];

// ── Price unit helper ───────────────────────────────────
function updatePriceHint(id) {
  const el = document.getElementById(id);
  const hint = document.getElementById(id + '-hint');
  if (!el || !hint) return;
  const n = parseFloat(el.value);
  if (!isNaN(n) && n >= 1000) {
    hint.textContent = `≈ ${(n / 1000).toFixed(2).replace(/\.?0+$/, '')} M`;
    hint.style.display = 'inline';
  } else {
    hint.style.display = 'none';
  }
}

// ── Map preview with Leaflet ────────────────────────────
let _map = null;
let _marker = null;
function initMap() {
  if (_map) return;
  const container = document.getElementById('map-preview');
  if (!container || typeof L === 'undefined') return;
  _map = L.map(container, { zoomControl: true }).setView([0, 0], 2);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap contributors'
  }).addTo(_map);
}
function updateMapMarker() {
  const lat = parseFloat(document.getElementById('proj-latitude')?.value);
  const lng = parseFloat(document.getElementById('proj-longitude')?.value);
  if (isNaN(lat) || isNaN(lng)) return;
  if (!_map) initMap();
  if (_marker) _marker.remove();
  _marker = L.marker([lat, lng]).addTo(_map);
  _map.setView([lat, lng], 14);
}

// ── Modal ────────────────────────────────────────────────
const modal = document.getElementById('project-modal');
const modalTitle = document.getElementById('modal-project-title');

export function initProjects() {
  document.getElementById('btn-add-project').addEventListener('click', () => openModal(null));
  document.getElementById('project-modal-close').addEventListener('click', closeModal);
  document.getElementById('project-cancel').addEventListener('click', closeModal);
  document.getElementById('project-save').addEventListener('click', saveProject);
  document.getElementById('project-search').addEventListener('input', renderTable);
  modal.addEventListener('click', (e) => { if (e.target === modal) closeModal(); });

  // Image uploads
  document.getElementById('project-mainimg-input').addEventListener('change', (e) => handleSingleUpload(e, 'projects/main', 'proj-mainImg-preview', true));
  document.getElementById('project-adimg-input').addEventListener('change', (e) => handleSingleUpload(e, 'projects/ads', 'proj-adImg-preview', false, 'proj-adImageUrl'));
  document.getElementById('project-sitemap-input').addEventListener('change', (e) => handleSingleUpload(e, 'projects/sitemap', 'proj-sitemap-preview', false, 'proj-sitemapUrl'));
  document.getElementById('project-gallery-input').addEventListener('change', handleGalleryUpload);

  // Price hints (informational – label always stays as "Juta")
  document.getElementById('proj-priceMin').addEventListener('input', () => updatePriceHint('proj-priceMin'));
  document.getElementById('proj-priceMax').addEventListener('input', () => updatePriceHint('proj-priceMax'));

  // Map preview on lat/lng change
  document.getElementById('proj-latitude').addEventListener('input', updateMapMarker);
  document.getElementById('proj-longitude').addEventListener('input', updateMapMarker);

  // Feature tag input
  document.getElementById('feature-tag-input').addEventListener('keydown', handleFeatureKey);

  // POI + Unit type add buttons – use arrow to avoid passing Event as argument
  document.getElementById('btn-add-poi').addEventListener('click', () => addPoiRow());
  document.getElementById('btn-add-unit').addEventListener('click', () => addUnitTypeRow());

  // Certificate "Other" - show text input
  document.getElementById('proj-certificateType').addEventListener('change', (e) => {
    const customWrap = document.getElementById('custom-cert-wrap');
    if (customWrap) customWrap.style.display = e.target.value === 'Other' ? 'block' : 'none';
  });

  // Load data — try ordered first, fall back to unordered if index missing
  function subscribeProjects(ordered = true) {
    const q = ordered
      ? query(collection(db, COL), orderBy('name'))
      : collection(db, COL);
    return onSnapshot(q,
      (snap) => {
        _projects = snap.docs.map(d => ({ id: d.id, ...d.data() }));
        renderTable();
        updateProjectCount();
      },
      (err) => {
        console.error('Projects snapshot error:', err);
        if (ordered && err.code === 'failed-precondition') {
          // Missing index — retry without ordering
          subscribeProjects(false);
        } else {
          const tbody = document.getElementById('projects-tbody');
          if (tbody) tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;padding:24px;color:#ef4444">
            Error loading projects: ${err.message}<br>
            <small style="color:#9ca3af">Check Firestore security rules and browser console.</small>
          </td></tr>`;
          showToast('Failed to load projects: ' + err.message, 'error');
        }
      }
    );
  }
  subscribeProjects();
}

function updateProjectCount() {
  const el = document.getElementById('stat-projects');
  if (el) el.textContent = _projects.length;
}

// ── Table render ─────────────────────────────────────────
function renderTable() {
  const search = (document.getElementById('project-search')?.value || '').toLowerCase();
  const filtered = search
    ? _projects.filter(p => (p.name||'').toLowerCase().includes(search) || (p.city||'').toLowerCase().includes(search))
    : _projects;

  const tbody = document.getElementById('projects-tbody');
  if (!filtered.length) {
    tbody.innerHTML = `<tr><td colspan="6"><div class="empty-state">
      <svg width="40" height="40" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-2 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/></svg>
      <p>No projects found</p></div></td></tr>`;
    return;
  }
  tbody.innerHTML = filtered.map(p => `
    <tr>
      <td>${p.imageUrl
        ? `<img class="project-thumb" src="${p.imageUrl}" alt="">`
        : `<div class="thumb-placeholder"><svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg></div>`
      }</td>
      <td><span class="project-name">${escHtml(p.name||'—')}</span></td>
      <td>${escHtml(p.city||'—')}</td>
      <td>${formatPriceRange(p.priceMin, p.priceMax)}</td>
      <td><span class="project-status ${statusClass(p.status)}">${escHtml(p.status||'On Going Project')}</span></td>
      <td><div class="actions">
        <button class="btn btn-edit btn-sm" onclick="window._editProject('${p.id}')">
          <svg width="13" height="13" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>Edit
        </button>
        <button class="btn btn-delete btn-sm" onclick="window._deleteProject('${p.id}','${escHtml(p.name||'')}')">
          <svg width="13" height="13" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>Delete
        </button>
      </div></td>
    </tr>`).join('');
}

// ── Open / Close modal ───────────────────────────────────
function openModal(project) {
  _editingId = project?.id ?? null;

  // Migrate old features (strings) to objects
  const rawFeatures = project?.features ?? [];
  _featuresList = rawFeatures.map(f =>
    typeof f === 'string' ? { name: f, imageUrl: '' } : f
  );
  _nearbyList = (project?.nearbyLocations ?? []).map(n => ({ ...n, id: n.id || crypto.randomUUID() }));
  _unitTypesList = (project?.unitTypes ?? []).map(u => ({ ...u, id: u.id || crypto.randomUUID() }));
  _galleryList = [...(project?.imageGallery ?? [])];

  modalTitle.textContent = project ? 'Edit Project' : 'Add Project';

  setField('proj-name', project?.name);
  setField('proj-description', project?.description);
  setField('proj-status', project?.status ?? 'On Going Project');
  setField('proj-subtitle', project?.subtitle);
  setField('proj-developerName', project?.developerName);
  // Handle certificateType – restore custom value if it's not a known option
  const knownCerts = ['', 'SHM', 'HGB', 'Strata', 'Other'];
  const certVal = project?.certificateType ?? '';
  if (certVal && !knownCerts.includes(certVal)) {
    setField('proj-certificateType', 'Other');
    setField('proj-certificateCustom', certVal);
    const w = document.getElementById('custom-cert-wrap'); if (w) w.style.display = 'block';
  } else {
    setField('proj-certificateType', certVal);
    setField('proj-certificateCustom', '');
    const w = document.getElementById('custom-cert-wrap'); if (w) w.style.display = 'none';
  }
  setField('proj-priceMin', project?.priceMin);
  setField('proj-priceMax', project?.priceMax);
  setField('proj-bedrooms', project?.bedrooms);
  setField('proj-landArea', project?.landArea);
  setField('proj-buildingArea', project?.buildingArea);
  setField('proj-stockRemaining', project?.stockRemaining);
  setField('proj-installmentStarting', project?.installmentStarting);
  setField('proj-fullAddress', project?.fullAddress);
  setField('proj-district', project?.district);
  setField('proj-city', project?.city);
  setField('proj-province', project?.province);
  setField('proj-latitude', project?.latitude);
  setField('proj-longitude', project?.longitude);
  setField('proj-brochureUrl', project?.brochureUrl);
  setField('proj-adImageUrl', project?.adImageUrl);
  setField('proj-sitemapUrl', project?.sitemapUrl);
  document.getElementById('proj-isFeatured').checked = project?.isFeatured ?? false;

  // Previews
  setImgPreview('proj-mainImg-preview', project?.imageUrl, 'No main image');
  setImgPreview('proj-adImg-preview', project?.adImageUrl, 'No ad image');
  setImgPreview('proj-sitemap-preview', project?.sitemapUrl, 'No site map');

  // Price hints
  updatePriceHint('proj-priceMin');
  updatePriceHint('proj-priceMax');

  renderFeatureTags();
  renderPOITable();
  renderUnitTypes();
  renderGallery();

  modal.classList.add('open');

  // Init map after modal opens (needs rendered DOM)
  setTimeout(() => {
    if (typeof L !== 'undefined') {
      initMap();
      if (project?.latitude && project?.longitude) updateMapMarker();
      else if (_map) _map.setView([0, 0], 2);
      _map?.invalidateSize();
    }
  }, 300);
}

function closeModal() {
  modal.classList.remove('open');
  // Reset map so it re-inits fresh next open
  if (_map) { _map.remove(); _map = null; _marker = null; }
}

function setField(id, val) { const el = document.getElementById(id); if (el) el.value = val ?? ''; }
function val(id) { return document.getElementById(id)?.value?.trim() ?? ''; }
function numOrNull(id) { const v = val(id); return v === '' ? null : parseFloat(v); }
function intOrNull(id) { const v = val(id); return v === '' ? null : parseInt(v, 10); }

function setImgPreview(previewId, url, emptyLabel) {
  const el = document.getElementById(previewId);
  if (!el) return;
  if (url) {
    el.innerHTML = `<img src="${escHtml(url)}" alt="preview" style="width:100%;height:100%;object-fit:cover;border-radius:8px;">`;
  } else {
    el.innerHTML = `<div style="display:flex;flex-direction:column;align-items:center;justify-content:center;height:100%;color:#9ca3af;gap:6px;font-size:12px">
      <svg width="24" height="24" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
      <span>${emptyLabel}</span></div>`;
  }
}

// ── Upload helpers ───────────────────────────────────────
async function handleSingleUpload(e, storagePath, previewId, isMainImage, hiddenFieldId) {
  const file = e.target.files[0];
  if (!file) return;
  const btnId = isMainImage ? 'proj-mainimg-upload-btn' : null;
  if (btnId) { const b = document.getElementById(btnId); if (b) { b.disabled = true; b.textContent = 'Uploading…'; } }
  try {
    const storageRef = ref(storage, `${storagePath}/${Date.now()}_${file.name}`);
    await uploadBytes(storageRef, file);
    const url = await getDownloadURL(storageRef);
    if (isMainImage) {
      // Add to gallery
      _galleryList.unshift(url);
      renderGallery();
      // Also set as imageUrl if gallery was empty before
      if (_galleryList.length === 1) {
        document.getElementById('proj-mainImg-url-store').value = url;
        setImgPreview(previewId, url, 'No main image');
      } else {
        setImgPreview(previewId, _galleryList[0], 'No main image');
      }
    } else {
      if (hiddenFieldId) setField(hiddenFieldId, url);
      setImgPreview(previewId, url, '');
    }
    showToast('Image uploaded!', 'success');
  } catch (err) {
    showToast('Upload failed: ' + err.message, 'error');
  } finally {
    if (btnId) { const b = document.getElementById(btnId); if (b) { b.disabled = false; b.textContent = 'Upload Image'; } }
    e.target.value = '';
  }
}

async function handleGalleryUpload(e) {
  const files = Array.from(e.target.files);
  if (!files.length) return;
  showToast('Uploading ' + files.length + ' image(s)…');
  for (const file of files) {
    try {
      const storageRef = ref(storage, `projects/gallery/${Date.now()}_${file.name}`);
      await uploadBytes(storageRef, file);
      const url = await getDownloadURL(storageRef);
      _galleryList.push(url);
    } catch (err) {
      showToast('Failed: ' + err.message, 'error');
    }
  }
  renderGallery();
  showToast('Gallery updated!', 'success');
  e.target.value = '';
}

function renderGallery() {
  const container = document.getElementById('gallery-container');
  if (!container) return;
  // First image is always the main image
  if (_galleryList.length === 0) {
    setImgPreview('proj-mainImg-preview', null, 'No main image');
    document.getElementById('proj-mainImg-url-store').value = '';
  } else {
    setImgPreview('proj-mainImg-preview', _galleryList[0], 'No main image');
    document.getElementById('proj-mainImg-url-store').value = _galleryList[0];
  }
  container.innerHTML = _galleryList.map((url, i) => `
    <div style="position:relative;flex-shrink:0">
      <img src="${escHtml(url)}" style="width:80px;height:60px;object-fit:cover;border-radius:6px;border:2px solid ${i===0?'var(--orange)':'#e5e7eb'}" title="${i===0?'Main image':''}">
      ${i===0?'<span style="position:absolute;bottom:2px;left:2px;background:var(--orange);color:#fff;font-size:9px;padding:1px 4px;border-radius:3px">MAIN</span>':''}
      <button onclick="window._removeGalleryImg(${i})" style="position:absolute;top:-6px;right:-6px;width:18px;height:18px;border-radius:50%;background:#ef4444;border:none;color:#fff;font-size:12px;cursor:pointer;display:flex;align-items:center;justify-content:center;line-height:1">×</button>
    </div>`).join('');
}
window._removeGalleryImg = (i) => { _galleryList.splice(i, 1); renderGallery(); };

// ── Features ─────────────────────────────────────────────
function handleFeatureKey(e) {
  if (e.key === 'Enter' || e.key === ',') {
    e.preventDefault();
    const v = e.target.value.trim();
    if (v && !_featuresList.find(f => f.name === v)) {
      _featuresList.push({ name: v, imageUrl: '' });
      renderFeatureTags();
    }
    e.target.value = '';
  }
}

function renderFeatureTags() {
  const container = document.getElementById('feature-tags-container');
  if (!container) return;
  container.innerHTML = _featuresList.map((f, i) => `
    <div class="feature-item" style="display:flex;align-items:center;gap:8px;padding:8px;background:#f9fafb;border:1px solid #e5e7eb;border-radius:8px;margin-bottom:6px">
      <div style="flex-shrink:0">
        <label style="cursor:pointer;position:relative;display:block">
          <div style="width:40px;height:40px;border-radius:6px;overflow:hidden;border:1.5px dashed #d1d5db;background:#f3f4f6;display:flex;align-items:center;justify-content:center">
            ${f.imageUrl
              ? `<img src="${escHtml(f.imageUrl)}" style="width:100%;height:100%;object-fit:cover">`
              : `<svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="#9ca3af"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4v16m8-8H4"/></svg>`
            }
          </div>
          <input type="file" accept="image/*" style="display:none" onchange="window._uploadFeatureImg(${i}, this)">
        </label>
      </div>
      <span style="flex:1;font-size:13px;font-weight:500">${escHtml(f.name)}</span>
      <button onclick="window._removeFeature(${i})" style="background:#FEF2F2;border:none;color:#DC2626;border-radius:6px;padding:4px 8px;cursor:pointer;font-size:12px">×</button>
    </div>`).join('');
}

window._removeFeature = (i) => { _featuresList.splice(i, 1); renderFeatureTags(); };
window._uploadFeatureImg = async (i, input) => {
  const file = input.files[0];
  if (!file) return;
  try {
    const storageRef = ref(storage, `projects/features/${Date.now()}_${file.name}`);
    await uploadBytes(storageRef, file);
    const url = await getDownloadURL(storageRef);
    _featuresList[i].imageUrl = url;
    renderFeatureTags();
    showToast('Feature image uploaded!', 'success');
  } catch (err) {
    showToast('Upload failed: ' + err.message, 'error');
  }
};

// ── Nearby POIs ──────────────────────────────────────────
function addPoiRow(poi) {
  const id = poi?.id || crypto.randomUUID();
  const entry = poi || { id, name: '', category: 'Pusat Perbelanjaan', distance: '', distanceUnit: 'KM' };
  if (!poi) _nearbyList.push(entry);
  renderPOITable();
}

function renderPOITable() {
  const tbody = document.getElementById('poi-tbody');
  if (!tbody) return;
  if (!_nearbyList.length) {
    tbody.innerHTML = `<tr><td colspan="4" style="text-align:center;padding:16px;color:#9ca3af;font-size:13px">No POIs added. Click "Add POI".</td></tr>`;
    return;
  }
  tbody.innerHTML = _nearbyList.map((poi, i) => `
    <tr>
      <td><input type="text" value="${escHtml(poi.name)}" placeholder="e.g. Trans Studio Mall"
          onchange="window._poiChange(${i},'name',this.value)"
          style="width:100%;border:1px solid #e5e7eb;border-radius:6px;padding:6px 8px;font-size:12px;font-family:inherit"></td>
      <td><select onchange="window._poiChange(${i},'category',this.value)" style="width:100%;border:1px solid #e5e7eb;border-radius:6px;padding:6px 8px;font-size:12px;font-family:inherit">
        ${POI_CATEGORIES.map(c => `<option value="${c}" ${poi.category===c?'selected':''}>${c}</option>`).join('')}
      </select></td>
      <td style="display:flex;gap:4px;align-items:center">
        <input type="number" value="${poi.distance}" placeholder="0" min="0" step="0.1"
            onchange="window._poiChange(${i},'distance',parseFloat(this.value)||0)"
            style="width:60px;border:1px solid #e5e7eb;border-radius:6px;padding:6px 8px;font-size:12px;font-family:inherit">
        <select onchange="window._poiChange(${i},'distanceUnit',this.value)" style="border:1px solid #e5e7eb;border-radius:6px;padding:6px 8px;font-size:12px;font-family:inherit">
          <option value="KM" ${poi.distanceUnit==='KM'?'selected':''}>KM</option>
          <option value="MENIT" ${poi.distanceUnit==='MENIT'?'selected':''}>Menit</option>
        </select>
      </td>
      <td><button onclick="window._removePoi(${i})" class="btn btn-delete btn-sm">×</button></td>
    </tr>`).join('');
}

window._poiChange = (i, field, value) => { _nearbyList[i][field] = value; };
window._removePoi = (i) => { _nearbyList.splice(i, 1); renderPOITable(); };

// ── Unit Types ───────────────────────────────────────────
function addUnitTypeRow(unitType) {
  const id = unitType?.id || crypto.randomUUID();
  const entry = unitType || { id, name: '', price: 0, landArea: 0, buildingArea: 0, bedrooms: 1, bathrooms: 1, floors: 1, imageUrl: '' };
  if (!unitType) _unitTypesList.push(entry);
  renderUnitTypes();
}

function renderUnitTypes() {
  const container = document.getElementById('unit-types-container');
  if (!container) return;
  if (!_unitTypesList.length) {
    container.innerHTML = `<p style="text-align:center;color:#9ca3af;font-size:13px;padding:16px">No unit types added. Click "Add Unit Type".</p>`;
    return;
  }
  container.innerHTML = _unitTypesList.map((u, i) => `
    <div style="border:1px solid #e5e7eb;border-radius:10px;padding:14px;margin-bottom:10px;background:#fafafa">
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px">
        <span style="font-weight:600;font-size:13px;color:#013235">Unit Type ${i+1}</span>
        <button onclick="window._removeUnit(${i})" class="btn btn-delete btn-sm">Remove</button>
      </div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px">
        <div><label style="font-size:11px;font-weight:600;color:#6b7280;text-transform:uppercase;display:block;margin-bottom:4px">Type Name</label>
          <input type="text" value="${escHtml(u.name)}" placeholder="e.g. Type 36"
              onchange="window._unitChange(${i},'name',this.value)"
              style="width:100%;border:1px solid #e5e7eb;border-radius:6px;padding:6px 8px;font-size:13px;font-family:inherit"></div>
        <div><label style="font-size:11px;font-weight:600;color:#6b7280;text-transform:uppercase;display:block;margin-bottom:4px">Price (Juta)</label>
          <input type="number" value="${u.price}" placeholder="e.g. 500"
              onchange="window._unitChange(${i},'price',parseFloat(this.value)||0)"
              style="width:100%;border:1px solid #e5e7eb;border-radius:6px;padding:6px 8px;font-size:13px;font-family:inherit"></div>
        <div><label style="font-size:11px;font-weight:600;color:#6b7280;text-transform:uppercase;display:block;margin-bottom:4px">Land Area (m²)</label>
          <input type="number" value="${u.landArea}" placeholder="e.g. 72"
              onchange="window._unitChange(${i},'landArea',parseFloat(this.value)||0)"
              style="width:100%;border:1px solid #e5e7eb;border-radius:6px;padding:6px 8px;font-size:13px;font-family:inherit"></div>
        <div><label style="font-size:11px;font-weight:600;color:#6b7280;text-transform:uppercase;display:block;margin-bottom:4px">Building Area (m²)</label>
          <input type="number" value="${u.buildingArea}" placeholder="e.g. 36"
              onchange="window._unitChange(${i},'buildingArea',parseFloat(this.value)||0)"
              style="width:100%;border:1px solid #e5e7eb;border-radius:6px;padding:6px 8px;font-size:13px;font-family:inherit"></div>
        <div><label style="font-size:11px;font-weight:600;color:#6b7280;text-transform:uppercase;display:block;margin-bottom:4px">Bedrooms (KT)</label>
          <input type="number" value="${u.bedrooms}" min="0"
              onchange="window._unitChange(${i},'bedrooms',parseInt(this.value)||0)"
              style="width:100%;border:1px solid #e5e7eb;border-radius:6px;padding:6px 8px;font-size:13px;font-family:inherit"></div>
        <div><label style="font-size:11px;font-weight:600;color:#6b7280;text-transform:uppercase;display:block;margin-bottom:4px">Bathrooms (KM)</label>
          <input type="number" value="${u.bathrooms}" min="0"
              onchange="window._unitChange(${i},'bathrooms',parseInt(this.value)||0)"
              style="width:100%;border:1px solid #e5e7eb;border-radius:6px;padding:6px 8px;font-size:13px;font-family:inherit"></div>
        <div><label style="font-size:11px;font-weight:600;color:#6b7280;text-transform:uppercase;display:block;margin-bottom:4px">Floors</label>
          <input type="number" value="${u.floors}" min="1"
              onchange="window._unitChange(${i},'floors',parseInt(this.value)||1)"
              style="width:100%;border:1px solid #e5e7eb;border-radius:6px;padding:6px 8px;font-size:13px;font-family:inherit"></div>
        <div><label style="font-size:11px;font-weight:600;color:#6b7280;text-transform:uppercase;display:block;margin-bottom:4px">Unit Image</label>
          <label style="cursor:pointer;display:flex;align-items:center;gap:8px">
            <div style="width:50px;height:50px;border-radius:6px;overflow:hidden;border:1.5px dashed #d1d5db;background:#f3f4f6;display:flex;align-items:center;justify-content:center;flex-shrink:0">
              ${u.imageUrl
                ? `<img src="${escHtml(u.imageUrl)}" style="width:100%;height:100%;object-fit:cover">`
                : `<svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="#9ca3af"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4v16m8-8H4"/></svg>`
              }
            </div>
            <span style="font-size:11px;color:#6b7280">Upload</span>
            <input type="file" accept="image/*" style="display:none" onchange="window._uploadUnitImg(${i},this)">
          </label>
        </div>
      </div>
    </div>`).join('');
}

window._unitChange = (i, field, value) => { _unitTypesList[i][field] = value; };
window._removeUnit = (i) => { _unitTypesList.splice(i, 1); renderUnitTypes(); };
window._uploadUnitImg = async (i, input) => {
  const file = input.files[0];
  if (!file) return;
  try {
    const storageRef = ref(storage, `projects/units/${Date.now()}_${file.name}`);
    await uploadBytes(storageRef, file);
    const url = await getDownloadURL(storageRef);
    _unitTypesList[i].imageUrl = url;
    renderUnitTypes();
    showToast('Unit image uploaded!', 'success');
  } catch (err) {
    showToast('Upload failed: ' + err.message, 'error');
  }
};

// ── Save ─────────────────────────────────────────────────
async function saveProject() {
  const name = val('proj-name');
  if (!name) { showToast('Project name is required', 'error'); return; }

  const btn = document.getElementById('project-save');
  btn.disabled = true; btn.textContent = 'Saving…';

  try {
    const id = _editingId || crypto.randomUUID();
    const mainImageUrl = document.getElementById('proj-mainImg-url-store')?.value?.trim() || _galleryList[0] || '';
    const data = {
      id,
      name,
      description: val('proj-description'),
      status: val('proj-status') || 'On Going Project',
      imageUrl: mainImageUrl,
      imageGallery: _galleryList,
      adImageUrl: val('proj-adImageUrl'),
      sitemapUrl: val('proj-sitemapUrl'),
      subtitle: val('proj-subtitle'),
      developerName: val('proj-developerName'),
      certificateType: val('proj-certificateType') === 'Other'
        ? (val('proj-certificateCustom') || 'Other')
        : val('proj-certificateType'),
      priceMin: numOrNull('proj-priceMin'),
      priceMax: numOrNull('proj-priceMax'),
      bedrooms: intOrNull('proj-bedrooms'),
      landArea: numOrNull('proj-landArea'),
      buildingArea: numOrNull('proj-buildingArea'),
      stockRemaining: intOrNull('proj-stockRemaining'),
      installmentStarting: numOrNull('proj-installmentStarting'),
      fullAddress: val('proj-fullAddress'),
      district: val('proj-district'),
      city: val('proj-city'),
      province: val('proj-province'),
      latitude: numOrNull('proj-latitude'),
      longitude: numOrNull('proj-longitude'),
      brochureUrl: val('proj-brochureUrl'),
      isFeatured: document.getElementById('proj-isFeatured').checked,
      features: _featuresList,
      nearbyLocations: _nearbyList.filter(p => p.name),
      unitTypes: _unitTypesList.filter(u => u.name),
      lastUpdated: new Date().toISOString(),
    };
    await setDoc(doc(db, COL, id), data);
    showToast(_editingId ? 'Project updated!' : 'Project added!', 'success');
    closeModal();
  } catch (e) {
    showToast('Error: ' + e.message, 'error');
  } finally {
    btn.disabled = false; btn.textContent = 'Save Project';
  }
}

// ── Globals ───────────────────────────────────────────────
window._editProject = (id) => { openModal(_projects.find(x => x.id === id)); };
window._deleteProject = async (id, name) => {
  if (!confirm(`Delete project "${name}"? This cannot be undone.`)) return;
  try { await deleteDoc(doc(db, COL, id)); showToast('Project deleted', 'success'); }
  catch (e) { showToast('Error: ' + e.message, 'error'); }
};

// ── Helpers ───────────────────────────────────────────────
function escHtml(s) { return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
function formatPriceRange(min, max) {
  if (!min && !max) return '—';
  const fmt = (v) => v >= 1000 ? `${(v/1000).toFixed(1)} M` : `${v} Jt`;
  if (min && max) return `Rp${fmt(min)} – Rp${fmt(max)}`;
  return `Rp${fmt(min || max)}`;
}
function statusClass(s) {
  if (!s) return 'status-ongoing';
  const l = s.toLowerCase();
  if (l.includes('complet')) return 'status-completed';
  if (l.includes('upcom') || l.includes('soon')) return 'status-upcoming';
  return 'status-ongoing';
}
