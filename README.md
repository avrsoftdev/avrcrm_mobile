# AVRCRM

AVRCRM is a Flutter + Firebase CRM application for CRM, Sales, Finance, Inventory, Marketing and HR.

## Architecture

Flutter UI -> Services/Repositories -> Tenant-aware Firestore -> Firebase Authentication.

Administrative user management is handled by Firebase Cloud Functions so an administrator can create/disable users without exposing Firebase Admin credentials to the Flutter app.

## Main modules

- Authentication and company onboarding
- Contacts with bulk CSV import
- Leads and deals
- Quotes, orders, invoices and payments
- Inventory
- Marketing campaigns, lists and templates
- HR One / employees
- Dashboard analytics
- Users, roles and permissions
- Audit logging
- Theme/settings

## Firestore tenancy

Every business document is stored with:

- companyId
- createdBy
- createdAt
- updatedBy
- updatedAt
- isDeleted

This prevents one company's records from being queried by another company.

## Firebase setup

1. Install Flutter and Firebase CLI.
2. Run `flutter pub get`.
3. Verify `lib/firebase_options.dart` points to your Firebase project. If you change Firebase projects, run `flutterfire configure`.
4. Deploy rules: `firebase deploy --only firestore:rules,firestore:indexes`.
5. Install and build functions: `cd functions && npm install && npm run build`.
6. Deploy functions: `npm run deploy`.
7. Enable Email/Password authentication in Firebase Authentication.

## Important

The Firebase web/android API key in `firebase_options.dart` is configuration, not a server secret. Never put Firebase Admin SDK service-account JSON or Admin credentials in the Flutter application.

## Production recommendations

- Enable App Check before production launch.
- Keep Firestore rules enabled; do not switch to test mode.
- Use Cloud Functions for administrative user creation and sensitive operations.
- Add Storage only when document/logo uploads are required.
- Enable scheduled backups/export for production data.
