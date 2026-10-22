# Server and public privacy follow-up

The mobile client now preserves explicit HTTPS and validates server certificates normally. This does not enable TLS on the server.

## Verified blocker

The supplied review server is http://egytest.ddns.net:8644/api/v1. A direct TLS probe of the same host and port failed with a corrupted/invalid frame. No HTTPS claim is justified for this endpoint.

## To enable HTTPS

Locate the deployed API service and its public reverse proxy. Provision a DNS name with a valid public TLS certificate, forward HTTPS requests to the API on a private/loopback connection, and verify the certificate chain from an ordinary client. Keep /api/v1 and all existing API routes intact. The public HTTPS origin should be entered into AVMS Owner and the reviewer instructions updated after a successful login test. No server configuration has been changed from this repository.

## Public account deletion page

Update the owner's existing privacy URL https://avms.egytwins.com/docs/privacy-policy.html to prominently name AVMS Owner and EgyTwins, describe the web request method and identity verification, identify data deleted, and explain retained records and their actual retention period. Following the owner's reference to Visitor System, the local app now offers Account > Delete my account, confirms intent, calls the same authenticated POST /api/v1/user/delete contract with the current user's ID, then clears the session after success. The email-only request dialog has been replaced. No live account was deleted during testing. The reference mobile source does not establish whether the backend retains invitation/audit/backup records or for how long.

The existing privacy page uses a different contact address and promises HTTPS for all transmissions. Align it with the actual deployed mobile service before submitting the Data safety declaration. Do not publish an invented retention period or claim that related records are erased without verifying backend behavior.
