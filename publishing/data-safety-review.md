# AVMS Owner — saved Data safety declaration

Completed and saved in Play Console on 19 October 2026 for com.egytwins.avms, app ID 4972253130712199391. Google displayed: changes saved; send them for review from Publishing overview. This is not confirmation of review submission or approval.

## Evidence

Reviewed active registration/sign-in, invitation creation, user/account management, device ID and image selection flows, dependency/manifest declarations, the existing account-deletion implementation, and the owner-supplied public privacy policy. Prepared publishing/data-safety-import.csv from Google's own exported 782-row CSV schema, imported it, checked the completed data-use sections and store preview, then saved.

## Saved answers

- Collects/shares required user data: Yes.
- All data encrypted in transit: No. The review endpoint uses HTTP; the mobile code now preserves HTTPS when explicitly configured but does not make this HTTP server encrypted.
- Account creation: username/password.
- Account deletion URL: https://avms.egytwins.com/docs/privacy-policy.html, as supplied by the owner. The app itself has Account > Delete my account, using the same authenticated API contract as Visitor System.
- Requests for deletion of some/all data without deleting the account: Yes, with the same policy URL. Basis: the published policy's erasure-rights/contact mechanism, with handling coordinated with the operating organization and subject to legal retention. No automatic 90-day deletion claim was made.
- No independent security, payments or family-program badge claimed.

| Data type | Collected | Shared | Optional | Collection purposes |
| --- | --- | --- | --- | --- |
| Name | Yes | Yes | No | App functionality, account management, security |
| Email address | Yes | Yes | No | App functionality, account management |
| User IDs | Yes | Yes | No | App functionality, account management, security |
| Phone number | Yes | Yes | No | App functionality, account management |
| Other personal info | Yes | Yes | No | App functionality, security |
| Photos | Yes | Yes | Yes | App functionality, account management, security |
| Other app actions | Yes | Yes | No | App functionality, security |
| Device/other IDs | Yes | No | No | App functionality, account management, security |

Other personal info covers visitor identity-document numbers and unit/area associations. Other app actions covers invitation/administrative records. Personal photographs are optional; the bundled placeholder is not a user photograph. No selected data type was described as ephemeral.

Sharing was disclosed for the account/visitor/operational records because the public policy says authorized facility operators can access them and credentials may pass to access-control integrations. Hosting providers acting under the publisher's instructions, legal transfers and explicit user-directed QR sharing have applicable Google exceptions, so those alone were not used to claim additional unrelated sharing. Mobile device identifiers are sent for authentication; no onward device-ID transfer was identified in the reviewed material.

No advertising/marketing, app-usage analytics, developer-marketing communications or personalization purpose was selected. No mobile GPS capture, contacts access, installed-app inventory, advertising identifier, mobile biometrics capture, financial/health or web-browsing-history collection was found in the reviewed flows. Broader kiosk/terminal features mentioned in the platform privacy policy were not automatically attributed to this mobile client.

## Remaining release issues

The saved declaration is not proof that the backend physically erases all related records/backups. The owner confirmed that deleting through the app removes the visible account. The public policy still needs clearer AVMS Owner applicability and prominent account-deletion/retained-record details. Its blanket HTTPS claim conflicts with the supplied HTTP review endpoint. Those website/server issues were not changed by saving this form.

Sources:
- https://avms.egytwins.com/docs/privacy-policy.html
- https://support.google.com/googleplay/android-developer/answer/10787469?hl=ar
