import { db } from './firebase-config.js';
import {
  collection, doc, setDoc, deleteDoc, onSnapshot,
  orderBy, query, getDoc
} from 'https://www.gstatic.com/firebasejs/10.14.1/firebase-firestore.js';
import { showToast } from './ui-helpers.js';

const COL = 'contacts';
const SETTINGS_DOC = 'settings/app_settings';
let _contacts = [];
let _editingId = null;

// ── Office Location ──────────────────────────────────────
let _officeMap = null;
let _officeMarker = null;

function initOfficeMap() {
  if (_officeMap || typeof L === 'undefined') return;
  const container = document.getElementById('office-map-preview');
  if (!container) return;
  _officeMap = L.map(container, { zoomControl: true }).setView([-5.147665, 119.432732], 13);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap contributors'
  }).addTo(_officeMap);
}

function updateOfficeMapMarker() {
  const lat = parseFloat(document.getElementById('office-lat')?.value);
  const lng = parseFloat(document.getElementById('office-lng')?.value);
  if (isNaN(lat) || isNaN(lng)) return;
  if (!_officeMap) initOfficeMap();
  if (_officeMarker) _officeMarker.remove();
  _officeMarker = L.marker([lat, lng]).addTo(_officeMap);
  _officeMap.setView([lat, lng], 15);
}

async function loadOfficeLocation() {
  try {
    const snap = await getDoc(doc(db, 'settings', 'app_settings'));
    if (snap.exists()) {
      const d = snap.data();
      const lat = d.officeLatitude ?? '';
      const lng = d.officeLongitude ?? '';
      const latEl = document.getElementById('office-lat');
      const lngEl = document.getElementById('office-lng');
      if (latEl) latEl.value = lat;
      if (lngEl) lngEl.value = lng;
      if (lat && lng) setTimeout(updateOfficeMapMarker, 100);
    }
  } catch (e) {
    console.warn('Could not load office location:', e);
  }
}

async function saveOfficeLocation() {
  const lat = parseFloat(document.getElementById('office-lat')?.value);
  const lng = parseFloat(document.getElementById('office-lng')?.value);
  if (isNaN(lat) || isNaN(lng)) {
    showToast('Please enter valid latitude and longitude', 'error'); return;
  }
  const btn = document.getElementById('btn-save-office-location');
  if (btn) { btn.disabled = true; btn.textContent = 'Saving…'; }
  try {
    await setDoc(doc(db, 'settings', 'app_settings'),
      { officeLatitude: lat, officeLongitude: lng }, { merge: true });
    showToast('Office location saved!', 'success');
  } catch (e) {
    showToast('Error: ' + e.message, 'error');
  } finally {
    if (btn) { btn.disabled = false; btn.textContent = 'Save Location'; }
  }
}

const modal = document.getElementById('contact-modal');

export function initContacts() {
  document.getElementById('btn-add-contact').addEventListener('click', () => openModal(null));
  document.getElementById('contact-modal-close').addEventListener('click', closeModal);
  document.getElementById('contact-cancel').addEventListener('click', closeModal);
  document.getElementById('contact-save').addEventListener('click', saveContact);
  modal.addEventListener('click', (e) => { if (e.target === modal) closeModal(); });

  // Office location
  document.getElementById('office-lat')?.addEventListener('input', updateOfficeMapMarker);
  document.getElementById('office-lng')?.addEventListener('input', updateOfficeMapMarker);
  document.getElementById('btn-save-office-location')?.addEventListener('click', saveOfficeLocation);
  setTimeout(() => { initOfficeMap(); loadOfficeLocation(); }, 300);

  const q = query(collection(db, COL), orderBy('order'));
  onSnapshot(q, (snap) => {
    _contacts = snap.docs.map(d => ({ id: d.id, ...d.data() }));
    renderTable();
    updateContactCount();
  });
}

function updateContactCount() {
  const el = document.getElementById('stat-contacts');
  if (el) el.textContent = _contacts.length;
}

function renderTable() {
  const tbody = document.getElementById('contacts-tbody');
  if (!_contacts.length) {
    tbody.innerHTML = `<tr><td colspan="5"><div class="empty-state">
      <svg width="40" height="40" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
      <p>No contacts found</p></div></td></tr>`;
    return;
  }
  tbody.innerHTML = _contacts.map(c => `
    <tr>
      <td>${c.profilePictureUrl
        ? `<img class="project-thumb" src="${c.profilePictureUrl}" alt="" style="border-radius:50%;width:40px;height:40px;object-fit:cover" onerror="this.style.display='none'">`
        : `<div style="width:40px;height:40px;border-radius:50%;background:#e5e7eb;display:flex;align-items:center;justify-content:center;font-weight:700;color:#9ca3af;font-size:16px">${(c.name||'?').charAt(0).toUpperCase()}</div>`
      }</td>
      <td><span class="project-name">${escHtml(c.name||'—')}</span></td>
      <td>${escHtml(c.description||'—')}</td>
      <td>${c.whatsappLink ? `<a href="${escHtml(c.whatsappLink)}" target="_blank" style="color:var(--green-800)">${escHtml(c.whatsappLink)}</a>` : '—'}</td>
      <td><div class="actions">
        <button class="btn btn-edit btn-sm" onclick="window._editContact('${c.id}')">
          <svg width="13" height="13" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
          Edit
        </button>
        <button class="btn btn-delete btn-sm" onclick="window._deleteContact('${c.id}', '${escHtml(c.name||'')}')">
          <svg width="13" height="13" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
          Delete
        </button>
      </div></td>
    </tr>`).join('');
}

function openModal(contact) {
  _editingId = contact?.id ?? null;
  document.getElementById('contact-modal-title').textContent = contact ? 'Edit Contact' : 'Add Contact';
  setField('ct-name', contact?.name);
  setField('ct-description', contact?.description);
  setField('ct-profilePictureUrl', contact?.profilePictureUrl);
  setField('ct-whatsappLink', contact?.whatsappLink);
  setField('ct-order', contact?.order ?? _contacts.length);
  modal.classList.add('open');
}

function closeModal() { modal.classList.remove('open'); }
function setField(id, val) { const el = document.getElementById(id); if (el) el.value = val ?? ''; }
function val(id) { return document.getElementById(id)?.value?.trim() ?? ''; }

async function saveContact() {
  const name = val('ct-name');
  if (!name) { showToast('Name is required', 'error'); return; }

  const btn = document.getElementById('contact-save');
  btn.disabled = true; btn.textContent = 'Saving…';

  try {
    const id = _editingId || crypto.randomUUID();
    await setDoc(doc(db, COL, id), {
      id,
      name,
      description: val('ct-description'),
      profilePictureUrl: val('ct-profilePictureUrl'),
      whatsappLink: val('ct-whatsappLink'),
      order: parseInt(val('ct-order'), 10) || 0,
    });
    showToast(_editingId ? 'Contact updated!' : 'Contact added!', 'success');
    closeModal();
  } catch (e) {
    showToast('Error: ' + e.message, 'error');
  } finally {
    btn.disabled = false; btn.textContent = 'Save Contact';
  }
}

window._editContact = (id) => { openModal(_contacts.find(c => c.id === id)); };
window._deleteContact = async (id, name) => {
  if (!confirm(`Delete contact "${name}"?`)) return;
  try {
    await deleteDoc(doc(db, COL, id));
    showToast('Contact deleted', 'success');
  } catch (e) {
    showToast('Error: ' + e.message, 'error');
  }
};

function escHtml(s) { return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
