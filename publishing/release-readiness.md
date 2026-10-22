# AVMS Owner release preparation

Package: `com.egytwins.avms`
Console app ID: `4972253130712199391`
Developer: EgyTwins Integrated Solutions

## Completed

- Created a separate AVMS Owner app on Google Play Console.
- Saved the Arabic store title, short description and full description as a draft. English copy is prepared in `store-listing.md`.
- Saved the owner-supplied privacy URL.
- Saved reviewer credentials and English instructions in the App access section. The owner confirmed full access without extra approval, OTP or device restrictions. The password is not saved in repository files.
- Saved support email `khaled.kararah@egytwins.com`.
- Saved Business category.
- Saved No for ads and advertising-ID usage. The client and merged Android manifest show no advertising SDK or advertising-ID permission.
- Saved No for government affiliation, financial features and health features.
- Saved the target audience as 18 years and older, based on the property-owner/administrator purpose.
- Completed IARC after the owner's explicit agreement to its terms. Console shows completed ratings including ESRB Everyone, PEGI 3 and IARC 3+.
- Uploaded and saved the existing 512×512 app icon and the generated 1024×500 feature graphic in the Arabic store-listing draft.
- Saved a partial Data safety draft: collects data = Yes; all data encrypted in transit = No; account creation = username/password; account deletion URL = the owner's supplied privacy URL. The detailed data-type/use/sharing sections remain incomplete.
- Uploaded the signed 1.0.0 (1) AAB. Google Play processed it and displayed the accepted App bundle with version code 1, version 1.0.0 and target SDK 36. Saved the internal-test release as a draft with Arabic release notes.

## Verified technical details

- Local bundle: `build/app/outputs/bundle/release/app-release.aab`, 47,647,225 bytes.
- Package: `com.egytwins.avms`; min SDK 24; target SDK 36 in the release merged manifest.
- Bundle signing certificate: CN=AVMS, OU=Mobile, O=Egytwins, L=Cairo, C=EG.
- The review server responds from outside the restricted tool network. The bare `/api/v1` root returns 404; that is not proof that the actual sign-in endpoint is unavailable.
- Privacy policy is publicly retrievable over HTTPS. Initial DNS failures were restricted-network artifacts.

## Outstanding issues

1. **Privacy-policy alignment:** the supplied policy promises HTTPS/TLS for every transmission, but this app constructs requests with HTTP. The policy footer lists web, kiosk and terminal editions without explicitly covering the owner mobile app. The policy contact is `support@avms.app`, different from the requested store support email.
2. **Account deletion:** the owner requested use of the privacy URL, and it is saved in the Data safety draft. The current page needs a prominent AVMS Owner account/data deletion request path, clear steps, data removed/retained and retention details. The client allows registration and administrator deletion of users, but a clear in-app path for users to request deletion of their own accounts was not found. The policy URL alone does not establish that this flow exists.
3. **Store screenshots:** at least two genuine phone screenshots remain required. The 512×512 icon was found at `android/app/src/main/res/play_store_512.png` and uploaded. The 1024×500 feature graphic is at `publishing/graphics/feature-graphic.png` and uploaded. The running emulator's existing session expired during inspection; no credentials were entered into the emulator and no screenshots containing personal records were uploaded.
4. **Data safety:** detailed collection, use and sharing answers still need completion and backend verification. See `data-safety-review.md`. Broader platform policy mentions biometrics that are not evident in this Flutter client's flows; do not declare their collection solely from the platform policy.
5. **Distribution:** production countries and any required testing or review steps must be configured before release.
6. **Release validation:** Google Play's internal-release review showed one warning only: no testers have been selected. No blocking bundle error was shown in that internal-release review. The draft was not rolled out.

Nothing has been submitted for production review or published publicly.

Final dashboard verification: application setup is **9 of 11 tasks complete**. The two unfinished setup tasks shown by Play Console are **Data safety** and **Store listing**. Internal testing shows **1 of 3 tasks complete**, with testers and release confirmation still pending.

## Policy references

- User data, including secure transmission: https://support.google.com/googleplay/android-developer/answer/10144311?hl=en
- Account deletion and public URL requirements: https://support.google.com/googleplay/android-developer/answer/13327111?hl=en

## Follow-up implementation (18 October 2026)

- Local working version is now 1.0.0+2; Console still contains uploaded version code 1 until the new bundle is built and uploaded.
- API address normalization preserves explicit HTTPS instead of stripping its scheme and forcing HTTP. Legacy host:port values retain HTTP compatibility. Three URL tests passed, including HTTPS, legacy addresses and malformed addresses.
- Removed the global TLS certificate-validation bypass. Invalid certificates now fail normal validation.
- Added an external privacy-policy link under Account.
- Added Arabic/English account-and-data deletion request instructions with an email-client action to the owner-supplied support address. This is a request path, not automatic backend deletion. Support handling, deleted/retained data and retention duration still require operator confirmation.
- Server setup now leads to Login and remembers that choice; full URL input with /api/v1 is accepted without duplicating the endpoint prefix.
- A read-only HTTPS probe of https://egytest.ddns.net:8644/api/v1 failed with an invalid/corrupted TLS frame. Do not certify encrypted transit until the actual server supports valid HTTPS and it is configured in the client.
- A native LDPlayer screenshot was exported at 720x1400 to screenshots/login.png. It is not yet uploaded. Authenticated feature screenshots remain outstanding; emulator clipboard input did not insert the requested text correctly, so no successful reviewer login is claimed.
- Targeted analyzer reported existing style/unused-code warnings and no errors before the last deletion-request UI addition. Final build and validation results are pending.
- Final 1.0.0+2 signed AAB build succeeded: build/app/outputs/bundle/release/app-release.aab (45.5 MB). It has not been uploaded; Console still has code 1.
- Final targeted analyzer completed with no errors and 60 style/unused-code diagnostics. URL tests: 3 passed.
- Two native, unedited screenshots are prepared: screenshots/login.png and screenshots/register.png (720x1400). Upload was attempted but not completed because native file-dialog text input did not take effect. No new Console screenshot save or release upload is claimed.
- Server/public-policy handoff is recorded in server-followup.md. HTTPS service access and deletion/retention answers are still needed from the operator.

## Visitor System deletion parity (18 October 2026)

The owner directed us to the local vistor_system project. Its auth provider submits the current user ID to POST user/delete, and its datasource resolves this beneath the configured /api/v1 origin. AVMS Owner already uses this same route for administrator user deletion.

AVMS Owner now has a separate Delete my account action in Account settings. It confirms intent, sends the signed-in user's ID with their bearer token to POST /api/v1/user/delete, blocks duplicate submissions, handles rejection/uncertain network results without automatic retry, and clears its local session and navigation after confirmed success. It replaces the earlier email-only deletion-request dialog.

Reference source: ../vistor_system/lib/features/auth/presentation/providers/auth_provider.dart and ../vistor_system/lib/features/auth/data/datasources/remote.dart. No files in that reference project were changed.

No live deletion was performed. Automated tests use a fake transport. Client source confirms the deletion API contract but does not establish server-side erasure of related invitation/audit/backups or their retention periods. Public privacy-page updates and valid HTTPS are still pending.

The updated local version is 1.0.0+3; version 3 is not uploaded to Console yet.
- Deletion follow-up validation: all 7 tests passed (3 URL normalization, 4 deletion behavior tests). Targeted analyzer reported no errors; existing styling/unused-code diagnostics remain. git diff --check passed.
- Final follow-up also aligns the privacy/deletion labels with the app's active Config translation language (the app does not currently wire its language switch to MaterialApp locale) and clears saved recovery email/session values after a confirmed deletion.
- Final signed 1.0.0 (3) AAB rebuild succeeded after the language/session cleanup follow-up: build/app/outputs/bundle/release/app-release.aab (45.5 MB). Merged release manifest confirms com.egytwins.avms, versionCode 3, versionName 1.0.0. Final targeted analyzer has no errors; git diff --check passes. This bundle is prepared locally and has not been uploaded to Google Play.

## Privacy link placement (19 October 2026)

The owner asked for the supplied policy to be linked from app settings and confirmed that deletion is initiated in the app and the account disappears afterward. This confirms visible account removal, not erasure/retention of every related server record. The supplied server remains the configured system endpoint; no new HTTPS endpoint or server deployment access was provided.

Added a visible Privacy policy entry directly to the main Settings screen, while keeping it accessible under Account. Both entries use the same component and the owner-supplied HTTPS policy URL. It opens the external browser; if opening fails, a dialog exposes the full selectable URL. Labels follow the app's Arabic/English selection. This links the existing public policy and does not modify its hosted content.

Local working version is 1.0.0+4. No new Console upload is claimed.
- Google Play accepted login.png and register.png (720x1400); both were added to the Arabic phone screenshot section and saved as a store-listing draft. Console displayed the success message that changes were saved. The previous native file-picker input blocker was overcome by setting the filename field and confirming with Return.
- The signed 1.0.0 (4) AAB build succeeded (45.5 MB); targeted analyzer reported no errors and git diff --check passed. The privacy link is included in this local bundle.
- Release 4 upload could not be completed: the native picker again returned inconsistent cached element/settable/secondary-action state for its filename/dialog controls. No release-4 upload or rollout is claimed. The screenshot upload/save completed successfully earlier in this session; those assets are now in the store draft.

## Successful Google Play bundle upload (19 October 2026)

- Uploaded the signed app-release.aab (47,719,810 bytes) through Chrome to AVMS Owner on EgyTwins, app ID 4972253130712199391.
- Google Play processed and accepted version code 4, version name 1.0.0, target SDK 36, min SDK 24.
- Replaced the code-1 attachment in the existing internal-test release draft with code 4. Console explicitly says the removed code-1 artifact remains available in its artifact library.
- Renamed the release to 1.0.0 (4) - AVMS Owner and saved it as a draft. Console confirmed the changes were saved and displayed only the code-4 bundle.
- Opened the release review page. It reports one warning: no testers have been selected, so the internal release would not be available to users. No bundle errors were shown.
- No Save and publish/rollout action was taken. Public distribution and remaining Data safety/privacy/HTTPS requirements are still outstanding.
- Native picker recovery succeeded on a fresh upload dialog by observing File name focus, using sky.type_text with the exact AAB path, then Return.

## Data safety questionnaire completed (19 October 2026)

Completed the declaration using the reviewed client behavior and published privacy policy. Exported Google's CSV schema, prepared/imported data-safety-import.csv, verified all selected data-use sections were complete and checked the final store preview. Clicked Save; Google confirmed that the change is saved and should be sent for review from Publishing overview. The form discloses eight collected data types, seven operational/personal/photo types shared with facility operations/integrations, no encrypted transit for the current HTTP server, optional personal photos and request-based deletion. Full evidence/answers and remaining public-policy/server issues are documented in data-safety-review.md. No review submission or public rollout was performed in this step.
- Verification after saving: App content overview reports that there are no new declaration forms required; completed forms are under the acted-on tab. Data safety is no longer an outstanding content-declaration task.

## Production submission preparation (19 October 2026)

- User explicitly requested submission and selected all available countries/regions. Saved 178 targeted countries/regions, including the rest-of-world option.
- Finished the default Arabic store listing's second step. Disclosed the generated feature graphic as AI-generated, leaving the existing logo and native app screenshots unlabelled. Google confirmed the default listing was updated and ready for review.
- Created production release 1 on track 4697679253123337154 with only version code 4 (1.0.0), named 1.0.0 (4) - AVMS Owner. Added Arabic initial-release notes. Google's release review said ready for release with no bundle errors; saved to Publishing overview.
- Publishing overview now contains 11 changes, including production full rollout and countries, store listing and content declarations. Quick checks identified limited clarity: screenshots allegedly consist of marketing graphics rather than in-app experience. Existing login/register uploads are native screenshots, but they do not demonstrate signed-in features.
- Google offers Continue anyway with an acknowledgment of possible rejection. Automatic approval review rejected confirming this acknowledgment without direct user consent. Asked the user to explicitly approve submission despite that warning or choose screenshot improvements. No submission is claimed yet.
- Follow-up: owner selected improving screenshots (three phone and three tablet) instead of overriding the warning. A fresh API login/read on the supplied review account succeeded and returned unit test1 (ID 4); verified the unit in the app after restarting/re-authenticating and selected it in the invitation form. No invitation was submitted.
- Built and installed the current release APK code 4 on LDPlayer for accurate screenshots. Three native phone screenshots are now under publishing/screenshots/phone (create invitation with test1, date-filtered invitations with no personal rows, Settings showing Privacy policy). Tablet capture is in progress at LDPlayer's 1920x1080 DPI280 tablet preset.

## Submission confirmed (19 October 2026)
- Replaced the two old login/register phone screenshots with three native in-app screenshots: invitation creation with unit test1 selected, invitations filtered to an empty date range (no visitor personal data), and settings with the privacy policy entry.
- Uploaded and saved three phone PNGs (720x1400) and three 7-inch tablet PNGs (1080x1920) from publishing/screenshots/phone and publishing/screenshots/tablet. No invitation was submitted for these captures.
- Saved the revised store listing successfully. Google restarted its automated pre-review checks.
- Confirmed Send 11 changes for review in Google Play Console. The publishing page changed from Changes not yet sent for review to Changes in review, with Remove changes available.
- At verification, automated quick checks were still running (Console displayed up to 14 minutes remaining). Console states that the changes will proceed to review automatically when checks succeed. This is submission acceptance/queue confirmation, not Google approval or confirmation that the automated checks have passed.
- Production submission: AVMS Owner 1.0.0 (4), com.egytwins.avms, full rollout, all selected available countries/regions plus rest of world. The existing com.app.avms app was not changed.
- Publishing URL: https://play.google.com/console/u/0/developers/6452670664905987807/app/4972253130712199391/publishing
