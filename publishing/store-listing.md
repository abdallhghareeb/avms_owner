# AVMS Owner — Google Play draft

Package: `com.egytwins.avms`
Play Console draft: https://play.google.com/console/u/0/developers/6452670664905987807/app/4972253130712199391/app-dashboard
Version: `1.0.0` (1)
Developer: EgyTwins Integrated Solutions
Suggested category: Business
Support email supplied by owner: khaled.kararah@egytwins.com
Review server supplied by owner: http://egytest.ddns.net:8644/api/v1
In this build's server setup field, use `egytest.ddns.net:8644`; the client adds the HTTP scheme and API path.
Dedicated reviewer credentials were supplied in the conversation; do not commit the password to this repository.

## English

App name: AVMS Owner

Short description:
Manage visitor invitations, QR passes and unit users with AVMS.

Full description:
AVMS Owner helps property owners and authorized unit administrators manage visitor invitations and users within an AVMS installation.

Create visitor invitations for your assigned units, set visit start and expiry times, and share QR invitation images with your guests. Review today's, upcoming and expired invitations from the dashboard, view invitation details, and cancel invitations when plans change.

Depending on your account permissions, you can also review user registration requests, accept or reject requests, and update or remove users associated with your units.

Features:
• Create visitor invitations with guest details and optional images.
• Set the invitation validity period and select the relevant unit or area.
• View and share QR invitation images.
• Track today's, upcoming and expired invitations.
• Manage unit users and registration requests according to your permissions.
• Use the app in Arabic or English.

AVMS Owner requires access to a compatible AVMS server and an authorized account. Your property or system administrator provides the server address and access details. Available features depend on your server configuration and account permissions.

## العربية

اسم التطبيق: AVMS Owner

الوصف المختصر:
إدارة دعوات الزوار ورموز QR ومستخدمي الوحدات لأصحاب العقارات ومديريها.

الوصف الكامل:
يساعد AVMS Owner أصحاب العقارات ومسؤولي الوحدات المصرح لهم على إدارة دعوات الزوار والمستخدمين ضمن منظومة AVMS.

أنشئ دعوات للزوار تخص الوحدات المرتبطة بحسابك، وحدد بداية الزيارة وانتهاء صلاحية الدعوة، وشارك صورة رمز QR مع ضيوفك. تابع دعوات اليوم والدعوات القادمة والمنتهية من لوحة المعلومات، واستعرض تفاصيل الدعوات وألغها عند تغيير الخطط.

بحسب صلاحيات حسابك، يمكنك أيضًا مراجعة طلبات تسجيل المستخدمين وقبولها أو رفضها، وتحديث المستخدمين المرتبطين بوحداتك أو حذفهم.

المميزات:
• إنشاء دعوات ببيانات الزائر وإضافة صورة اختياريًا.
• تحديد مدة صلاحية الدعوة والوحدة أو المنطقة المرتبطة بها.
• عرض صور رموز QR للدعوات ومشاركتها.
• متابعة دعوات اليوم والدعوات القادمة والمنتهية.
• إدارة مستخدمي الوحدات وطلبات التسجيل وفق الصلاحيات.
• دعم العربية والإنجليزية.

يتطلب التطبيق خادم AVMS متوافقًا وحسابًا مصرحًا له. يوفر مسؤول العقار أو النظام عنوان الخادم وبيانات الوصول. تعتمد الوظائف المتاحة على إعدادات الخادم وصلاحيات حسابك.

## Release notes

Initial release of AVMS Owner for visitor invitations, QR invitation sharing, invitation tracking and unit user management.

## Privacy URL supplied by owner

https://avms.egytwins.com/docs/privacy-policy.html

Verified reachable outside the restricted tool network. The initial DNS errors were caused by the restricted network and did not establish a public outage. The review server also responds; the bare API root returns HTTP 404, which does not establish a login failure.

Policy issues found: the policy claims HTTPS/TLS encryption for all transmissions, but this Flutter build constructs API requests using HTTP. Its footer explicitly lists web portal, kiosk edition and terminal edition, without naming AVMS Owner/mobile. It uses support@avms.app, whereas the owner supplied khaled.kararah@egytwins.com for store support. These details need alignment before release.

## Items requiring verification before submission

- Publicly accessible privacy policy covering this owner/admin app and its actual data handling.
- Data safety answers verified with the backend owner: names, email, phone, visitor identity documents, images, device identifiers and visit records are handled by the app. Retention, onward sharing and deletion behavior cannot be inferred from the Flutter client.
- Transport security: this client currently constructs API requests with HTTP, including when the entered server address originally used HTTPS. Do not declare that all collected data is encrypted in transit for this build.
- Account deletion: an administrator can delete users; a clear self-service account deletion request path and external deletion URL have not been established.
- Reviewer access: reachable server address, dedicated review credentials and any account approval/device binding instructions.
- Store graphics: icon, feature graphic and genuine app screenshots without personal data.
- Support contact, distribution countries, audience and content rating.
- Upload validation and Play signing enrollment for the new package.
