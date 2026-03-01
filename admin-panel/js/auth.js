import { auth } from './firebase-config.js';
import {
  signInWithEmailAndPassword,
  signOut,
  onAuthStateChanged
} from 'https://www.gstatic.com/firebasejs/10.14.1/firebase-auth.js';

/** Sign in and redirect to dashboard on success */
export async function loginWithEmail(email, password) {
  const cred = await signInWithEmailAndPassword(auth, email, password);
  return cred.user;
}

/** Sign out and redirect to login page */
export async function logout() {
  await signOut(auth);
  window.location.href = 'index.html';
}

/**
 * Auth guard — call this at the top of dashboard.html.
 * Resolves with the current user if logged in, else redirects.
 */
export function requireAuth() {
  return new Promise((resolve) => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      unsubscribe();
      if (user) {
        resolve(user);
      } else {
        window.location.href = 'index.html';
      }
    });
  });
}

/** Get current user email initial for avatar */
export function getUserInitial() {
  const user = auth.currentUser;
  if (!user || !user.email) return 'A';
  return user.email.charAt(0).toUpperCase();
}

export function getUserEmail() {
  return auth.currentUser?.email ?? '';
}
