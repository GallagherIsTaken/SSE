// Firebase configuration — same project as Flutter app
import { initializeApp } from 'https://www.gstatic.com/firebasejs/10.14.1/firebase-app.js';
import { getAuth } from 'https://www.gstatic.com/firebasejs/10.14.1/firebase-auth.js';
import { getFirestore } from 'https://www.gstatic.com/firebasejs/10.14.1/firebase-firestore.js';
import { getStorage } from 'https://www.gstatic.com/firebasejs/10.14.1/firebase-storage.js';

const firebaseConfig = {
  apiKey: "AIzaSyAu87kQJDkwGVVRt6rZVM60DpJXEtVfEuk",
  authDomain: "sumbersentuhanemas-9b281.firebaseapp.com",
  projectId: "sumbersentuhanemas-9b281",
  storageBucket: "sumbersentuhanemas-9b281.firebasestorage.app",
  messagingSenderId: "100077315251",
  appId: "1:100077315251:web:3abc9f04e5e9a4d05f7cc6"
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);
