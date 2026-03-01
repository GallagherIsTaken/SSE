import { db, storage } from './firebase-config.js';
import {
  collection, getDocs, doc, setDoc, deleteDoc, onSnapshot,
  orderBy, query, serverTimestamp
} from 'https://www.gstatic.com/firebasejs/10.14.1/firebase-firestore.js';
import { ref, uploadBytes, getDownloadURL } from 'https://www.gstatic.com/firebasejs/10.14.1/firebase-storage.js';
import { showToast } from './ui-helpers.js';

const COL = 'projects';
let _projects = [];
let _editingId = null;
let _featuresList = [];

// ── Modal references ────────────────────────────────────
const modal = document.getElementById('project-modal');
const modalTitle = document.getElementById('modal-project-title');

export function initProjects() {
  document.getElementById('btn-add-project').addEventListener('click', () => openModal(null));
  document.getElementById('project-modal-close').addEventListener('click', closeModal);
  document.getElementById('project-cancel').addEventListener('click', closeModal);
  document.getElementById('project-save').addEventListener('click', saveProject);
  document.getElementById('project-search').addEventListener('input', renderTable);
  document.getElementById('project-image-input').addEventListener('change', handleImageUpload);
  document.getElementById('feature-tag-input').addEventListener('keydown', handleFeatureKey);

  // Close on backdrop click
  modal.addEventListener('click', (e) => { if (e.target === modal) closeModal(); });

  // Load data
  const q = query(collection(db, COL), orderBy('name'));
  onSnapshot(q, (snap) => {
    _projects = snap.docs.map(d => ({ id: d.id, ...d.data() }));
    renderTable();
    updateProjectCount();
  });
}

function updateProjectCount() {
  const el = document.getElementById('stat-projects');
  if (el) el.textContent = _projects.length;
}

function renderTable() {
  const search = (document.getElementById('project-search')?.value || '').toLowerCase();
  const filtered = search
    ? _projects.filter(p => p.name?.toLowerCase().includes(search) || p.city?.toLowerCase().includes(search))
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
        ? `<img class="project-thumb" src="${p.imageUrl}" alt="" onerror="this.style.display='none'">`
        : `<div class="thumb-placeholder"><svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg></div>`
      }</td>
      <td><span class="project-name">${escHtml(p.name || '—')}</span></td>
      <td>${escHtml(p.city || '—')}</td>
      <td>${formatPrice(p.priceMin, p.priceMax)}</td>
      <td><span class="project-status ${statusClass(p.status)}">${escHtml(p.status || 'On Going Project')}</span></td>
      <td><div class="actions">
        <button class="btn btn-edit btn-sm" onclick="window._editProject('${p.id}')">
          <svg width="13" height="13" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
          Edit
        </button>
        <button class="btn btn-delete btn-sm" onclick="window._deleteProject('${p.id}', '${escHtml(p.name || '')}')">
          <svg width="13" height="13" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
          Delete
        </button>
      </div></td>
    </tr>`).join('');
}

function openModal(project) {
  _editingId = project?.id ?? null;
  _featuresList = [...(project?.features ?? [])];
  modalTitle.textContent = project ? 'Edit Project' : 'Add Project';

  // Fill fields
  setField('proj-name', project?.name);
  setField('proj-description', project?.description);
  setField('proj-status', project?.status ?? 'On Going Project');
  setField('proj-imageUrl', project?.imageUrl);
  setField('proj-subtitle', project?.subtitle);
  setField('proj-developerName', project?.developerName);
  setField('proj-certificateType', project?.certificateType);
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
  document.getElementById('proj-isFeatured').checked = project?.isFeatured ?? false;

  renderFeatureTags();
  modal.classList.add('open');
}

function closeModal() { modal.classList.remove('open'); }

function setField(id, val) {
  const el = document.getElementById(id);
  if (el) el.value = val ?? '';
}

function val(id) { return document.getElementById(id)?.value?.trim() ?? ''; }

async function saveProject() {
  const name = val('proj-name');
  if (!name) { showToast('Project name is required', 'error'); return; }

  const btn = document.getElementById('project-save');
  btn.disabled = true;
  btn.textContent = 'Saving…';

  try {
    const id = _editingId || crypto.randomUUID();
    const data = {
      id,
      name,
      description: val('proj-description'),
      status: val('proj-status') || 'On Going Project',
      imageUrl: val('proj-imageUrl'),
      subtitle: val('proj-subtitle'),
      developerName: val('proj-developerName'),
      certificateType: val('proj-certificateType'),
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
      imageGallery: [],
      nearbyLocations: [],
      unitTypes: [],
      lastUpdated: new Date().toISOString(),
    };

    await setDoc(doc(db, COL, id), data);
    showToast(_editingId ? 'Project updated!' : 'Project added!', 'success');
    closeModal();
  } catch (e) {
    showToast('Error: ' + e.message, 'error');
  } finally {
    btn.disabled = false;
    btn.textContent = 'Save Project';
  }
}

async function handleImageUpload(e) {
  const file = e.target.files[0];
  if (!file) return;
  const btn = document.getElementById('proj-upload-btn');
  btn.textContent = 'Uploading…';
  btn.disabled = true;
  try {
    const storageRef = ref(storage, `projects/${Date.now()}_${file.name}`);
    await uploadBytes(storageRef, file);
    const url = await getDownloadURL(storageRef);
    document.getElementById('proj-imageUrl').value = url;
    showToast('Image uploaded!', 'success');
  } catch (e) {
    showToast('Upload failed: ' + e.message, 'error');
  } finally {
    btn.textContent = 'Upload Image';
    btn.disabled = false;
  }
}

function handleFeatureKey(e) {
  if (e.key === 'Enter' || e.key === ',') {
    e.preventDefault();
    const v = e.target.value.trim();
    if (v && !_featuresList.includes(v)) {
      _featuresList.push(v);
      renderFeatureTags();
    }
    e.target.value = '';
  }
}

function renderFeatureTags() {
  const container = document.getElementById('feature-tags-container');
  container.innerHTML = _featuresList.map((f, i) =>
    `<span class="tag">${escHtml(f)}<button onclick="window._removeFeature(${i})">×</button></span>`
  ).join('');
}

window._removeFeature = (i) => { _featuresList.splice(i, 1); renderFeatureTags(); };
window._editProject = (id) => { const p = _projects.find(x => x.id === id); openModal(p); };
window._deleteProject = async (id, name) => {
  if (!confirm(`Delete project "${name}"? This cannot be undone.`)) return;
  try {
    await deleteDoc(doc(db, COL, id));
    showToast('Project deleted', 'success');
  } catch (e) {
    showToast('Error: ' + e.message, 'error');
  }
};

// ── Helpers ──────────────────────────────────────────────
function escHtml(s) { return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
function numOrNull(id) { const v = val(id); return v === '' ? null : parseFloat(v); }
function intOrNull(id) { const v = val(id); return v === '' ? null : parseInt(v, 10); }
function formatPrice(min, max) {
  if (!min && !max) return '—';
  if (min && max) return `Rp ${min}–${max} Juta`;
  return `Rp ${min || max} Juta`;
}
function statusClass(s) {
  if (!s) return 'status-ongoing';
  const l = s.toLowerCase();
  if (l.includes('complet')) return 'status-completed';
  if (l.includes('upcom') || l.includes('soon')) return 'status-upcoming';
  return 'status-ongoing';
}
