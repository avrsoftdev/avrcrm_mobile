import {onCall, HttpsError} from 'firebase-functions/v2/https';
import {onDocumentWritten} from 'firebase-functions/v2/firestore';
import {initializeApp} from 'firebase-admin/app';
import {getAuth} from 'firebase-admin/auth';
import {getFirestore, FieldValue} from 'firebase-admin/firestore';

initializeApp();
const db = getFirestore();
const auth = getAuth();

const DEFAULT_PERMISSIONS: Record<string, Record<string, boolean>> = {
  contacts: {view: true, create: true, edit: true, delete: false, export: true},
  leads: {view: true, create: true, edit: true, delete: false, export: true},
  deals: {view: true, create: true, edit: true, delete: false, export: true},
  quotes: {view: true, create: true, edit: true, delete: false, export: true},
  invoices: {view: true, create: true, edit: true, delete: false, export: true},
  payments: {view: true, create: true, edit: true, delete: false, export: true},
  inventory: {view: true, create: true, edit: true, delete: false, export: true},
  campaigns: {view: true, create: true, edit: true, delete: false, export: true},
  marketing_lists: {view: true, create: true, edit: true, delete: false, export: true},
  templates: {view: true, create: true, edit: true, delete: false, export: true},
  hr: {view: false, create: false, edit: false, delete: false, export: false},
  settings: {view: false, create: false, edit: false, delete: false, export: false},
};

async function requireAdmin(uid: string) {
  const snap = await db.collection('users').doc(uid).get();
  if (!snap.exists) throw new HttpsError('permission-denied', 'User profile not found.');
  const data = snap.data()!;
  if (!['admin', 'super_admin'].includes(String(data.role))) {
    throw new HttpsError('permission-denied', 'Administrator permission required.');
  }
  return data;
}

export const createManagedUser = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Sign-in required.');
  const admin = await requireAdmin(request.auth.uid);

  const email = String(request.data?.email ?? '').trim().toLowerCase();
  const name = String(request.data?.name ?? '').trim();
  const role = String(request.data?.role ?? 'staff').trim();
  const permissions = request.data?.permissions ?? DEFAULT_PERMISSIONS;
  if (!email || !name) throw new HttpsError('invalid-argument', 'Name and email are required.');

  const userRecord = await auth.createUser({email, displayName: name, emailVerified: false});
  const companyId = String(admin.companyId);
  await db.collection('users').doc(userRecord.uid).set({
    name, email, companyId, role, permissions, active: true,
    createdAt: FieldValue.serverTimestamp(), updatedAt: FieldValue.serverTimestamp(),
  });
  const passwordResetLink = await auth.generatePasswordResetLink(email);
  return {uid: userRecord.uid, passwordResetLink};
});

export const updateManagedUser = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Sign-in required.');
  const admin = await requireAdmin(request.auth.uid);
  const uid = String(request.data?.uid ?? '');
  if (!uid) throw new HttpsError('invalid-argument', 'User id is required.');

  const ref = db.collection('users').doc(uid);
  const snap = await ref.get();
  if (!snap.exists || snap.data()?.companyId !== admin.companyId) {
    throw new HttpsError('not-found', 'User not found.');
  }
  const patch: Record<string, unknown> = {};
  for (const key of ['name', 'role', 'active', 'permissions']) {
    if (request.data && request.data[key] !== undefined) patch[key] = request.data[key];
  }
  patch.updatedAt = FieldValue.serverTimestamp();
  await ref.update(patch);
  if (request.data?.active === false) await auth.updateUser(uid, {disabled: true});
  if (request.data?.active === true) await auth.updateUser(uid, {disabled: false});
  return {ok: true};
});

export const deleteManagedUser = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Sign-in required.');
  const admin = await requireAdmin(request.auth.uid);
  const uid = String(request.data?.uid ?? '');
  const snap = await db.collection('users').doc(uid).get();
  if (!snap.exists || snap.data()?.companyId !== admin.companyId) {
    throw new HttpsError('not-found', 'User not found.');
  }
  await db.collection('users').doc(uid).update({active: false, updatedAt: FieldValue.serverTimestamp()});
  await auth.updateUser(uid, {disabled: true});
  return {ok: true};
});

export const auditBusinessWrites = onDocumentWritten('{collectionId}/{documentId}', async (event) => {
  const after = event.data?.after.data();
  const before = event.data?.before.data();
  const companyId = after?.companyId ?? before?.companyId;
  if (!companyId || event.params.collectionId === 'audit_logs') return;
  await db.collection('audit_logs').add({
    companyId,
    collection: event.params.collectionId,
    documentId: event.params.documentId,
    type: !before ? 'create' : !after ? 'delete' : 'update',
    before: before ?? null,
    after: after ?? null,
    createdAt: FieldValue.serverTimestamp(),
  });
});
