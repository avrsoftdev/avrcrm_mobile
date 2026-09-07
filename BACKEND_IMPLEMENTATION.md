# AVRCRM Backend Implementation

## Included

### Flutter frontend
The existing AVRCRM UI is preserved, including Dashboard, CRM, Finance, Inventory, Marketing, HR and Settings screens.

### Backend foundation
- Firebase Authentication
- Tenant-aware Firestore access
- Company isolation via `companyId`
- Soft deletion
- Audit logging
- Document numbering service
- CRM repository
- Dashboard summary repository
- Generic module repository
- 100-template catalog seeder
- Bulk contact CSV import using the current FilePicker API
- Admin user management UI
- Role and permission matrix

### Cloud Functions
`functions/src/index.ts` provides:

- `createManagedUser`
- `updateManagedUser`
- `deleteManagedUser`
- `auditBusinessWrites`

The Flutter app never receives Firebase Admin credentials.

## Collections

`companies`, `users`, `contacts`, `leads`, `deals`, `quotes`, `orders`, `invoices`, `payments`, `inventory`, `campaigns`, `marketing_lists`, `templates`, `employees`, `attendance`, `leave_requests`, `notifications`, `audit_logs`, `counters`.

## Document envelope

Every business document created through `AppBackend` receives:

```text
companyId
createdBy
createdAt
updatedBy
updatedAt
isDeleted
```

## Roles

- admin
- super_admin
- sales
- marketing
- finance
- inventory
- hr
- staff

Each role can be restricted to module/action permissions:

`view`, `create`, `edit`, `delete`, `export`.

## Deployment

From the project root:

```text
flutter pub get
firebase deploy --only firestore:rules,firestore:indexes
cd functions
npm install
npm run build
npm run deploy
```

If you are using a different Firebase project, regenerate `lib/firebase_options.dart` with FlutterFire CLI before running the app.

## Important validation note

The provided environment does not contain the Flutter SDK, so `flutter analyze` / `flutter build` could not be executed here. The project was inspected statically and the backend integration was written against the APIs declared in `pubspec.yaml`. Run `flutter pub get` and `flutter analyze` on the development PC before deployment.
