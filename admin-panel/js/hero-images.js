import { db, storage } from './firebase-config.js';
import {
  collection, getDocs, doc, addDoc, deleteDoc, onSnapshot,
  orderBy, query
} from 'https://www.gstatic.com/firebasejs/10.14.1/firebase-firestore.js';
import { ref, uploadBytes, getDownloadURL } from 'https://www.gstatic.com/firebasejs/10.14.1/firebase-storage.js';
import { showToast } from './ui-helpers.js';

const COL = 'hero_images';
let _heroImages = [];

export function initHeroImages() {
  const dropzone = document.getElementById('hero-dropzone');
  const fileInput = document.getElementById('hero-file-input');
  const urlBtn = document.getElementById('hero-add-url');

  dropzone.addEventListener('click', () => fileInput.click());
  fileInput.addEventListener('change', (e) => handleFiles(e.target.files));

  dropzone.addEventListener('dragover', (e) => { e.preventDefault(); dropzone.classList.add('dragover'); });
  dropzone.addEventListener('dragleave', () => dropzone.classList.remove('dragover'));
  dropzone.addEventListener('drop', (e) => {
    e.preventDefault();
    dropzone.classList.remove('dragover');
    handleFiles(e.dataTransfer.files);
  });

  urlBtn.addEventListener('click', () => {
    const url = prompt('Enter image URL:');
    if (url?.trim()) addHeroImageUrl(url.trim());
  });

  const q = query(collection(db, COL), orderBy('order'));
  onSnapshot(q, (snap) => {
    _heroImages = snap.docs.map(d => ({ id: d.id, ...d.data() }));
    renderGrid();
    updateHeroCount();
  });
}

function updateHeroCount() {
  const el = document.getElementById('stat-hero');
  if (el) el.textContent = _heroImages.length;
}

function renderGrid() {
  const grid = document.getElementById('hero-grid');
  if (!_heroImages.length) {
    grid.innerHTML = `<div class="empty-state" style="grid-column:1/-1">
      <svg width="40" height="40" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
      <p>No hero images yet. Upload one above.</p>
    </div>`;
    return;
  }
  grid.innerHTML = _heroImages.map((img, idx) => `
    <div class="image-card">
      <img src="${img.imageUrl}" alt="Hero ${idx + 1}" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\\'http://www.w3.org/2000/svg\\' width=\\'100\\' height=\\'60\\'%3E%3Crect fill=\\'%23f3f4f6\\' width=\\'100\\' height=\\'60\\'/%3E%3C/svg%3E'">
      <div class="image-card-body">
        <span class="image-order">Order: ${img.order}</span>
        <button class="btn btn-delete btn-sm" onclick="window._deleteHeroImage('${img.id}')">
          <svg width="13" height="13" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
          Remove
        </button>
      </div>
    </div>`).join('');
}

async function handleFiles(files) {
  const dropzone = document.getElementById('hero-dropzone');
  for (const file of Array.from(files)) {
    if (!file.type.startsWith('image/')) continue;
    dropzone.querySelector('p').textContent = `Uploading ${file.name}…`;
    try {
      const storageRef = ref(storage, `hero_images/${Date.now()}_${file.name}`);
      await uploadBytes(storageRef, file);
      const url = await getDownloadURL(storageRef);
      await addHeroImageUrl(url);
    } catch (e) {
      showToast('Upload failed: ' + e.message, 'error');
    }
  }
  dropzone.querySelector('p').textContent = 'Click or drag & drop images here';
}

async function addHeroImageUrl(imageUrl) {
  try {
    const nextOrder = _heroImages.length
      ? Math.max(..._heroImages.map(i => i.order ?? 0)) + 1
      : 0;
    await addDoc(collection(db, COL), { imageUrl, order: nextOrder });
    showToast('Hero image added!', 'success');
  } catch (e) {
    showToast('Error: ' + e.message, 'error');
  }
}

window._deleteHeroImage = async (id) => {
  if (!confirm('Remove this hero image?')) return;
  try {
    await deleteDoc(doc(db, COL, id));
    showToast('Image removed', 'success');
  } catch (e) {
    showToast('Error: ' + e.message, 'error');
  }
};
