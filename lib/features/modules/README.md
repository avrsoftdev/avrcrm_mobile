# Functional module screens

The module tree is now backed by `FunctionalModuleScreen`. Every module screen supports:

- Create new record
- Edit existing record
- View record details
- Delete record
- Search across record fields
- Status filtering and status updates where a status field is configured
- Supabase persistence using the table configured for that module

Existing Leads, Contacts and Employees screens also support edit/delete and reuse their full existing forms.

The generic screens intentionally do not fake external services such as WhatsApp, payment gateways, Tally or e-invoice APIs. Those integrations should call real Supabase Edge Functions/API services when credentials and endpoints are configured.

## Database requirement

The module screen uses the Supabase table named in `all_feature_screens.dart`. Existing tables in the original project are reused. New module tables must exist in Supabase with columns matching the configured fields (or the form should be adapted to the project's final schema).
