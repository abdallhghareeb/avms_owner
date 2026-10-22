// Saved addresses include their scheme; never downgrade an explicit HTTPS URL.
const String BASE_URL = '';

/// Preserves HTTPS and accepts existing host:port configurations as HTTP.
/// Endpoint constants already contain /api/v1.
String normalizeApiUrl(String url) {
  var value = url.trim().replaceAll(RegExp(r'/+$'), '');
  value = value.replaceFirst(RegExp(r'/api/v1$', caseSensitive: false), '');
  if (value.isEmpty) return '';
  if (!RegExp(r'^[a-z][a-z0-9+.-]*://', caseSensitive: false).hasMatch(value)) {
    value = 'http://$value';
  }
  final uri = Uri.tryParse(value);
  if (uri == null ||
      !['http', 'https'].contains(uri.scheme.toLowerCase()) ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      uri.hasQuery ||
      uri.hasFragment ||
      (uri.path.isNotEmpty && uri.path != '/') ||
      RegExp(r'\s').hasMatch(value)) {
    return '';
  }
  return uri.replace(scheme: uri.scheme.toLowerCase(), path: '').toString();
}

String? TokenSave;
String? save;
String? RigisterSave;
String? ResetPassSave;
String? ConfigSave;
bool? SaveNavToLoginWhenSaveApiUrl;
String? saveEmail;
String? SaveApiUrl;
String? SaveEmailForgetPass;
String? SaveEmailRegisterToReset;
bool? forgetPassCheck;
bool? RegisterToResetCheck;
bool? hasLoggedInBefore;
const String GetAll = "/api/v1/area/get";
const String GetUnitWithId = "/api/v1/area/unit?unit_id=";
const String postSignInEndPoint = "/api/v1/auth/sign-in";
const String postSignUpEndPoint = "/api/v1/auth/register";

const String postForgetPasswordEndPoint = "/api/v1/Auth/forget-password";
const String postResetPasswordEndPoint = "/api/v1/Auth/reset-password";

const String getInvitationsReportEndPoint = "/api/v1/invitation/report";
const String getAllInvitationsEndPoint = "/api/v1/invitation/get-all";
const String getDashInfoEndPoint = "/api/v1/dashboard/TabsInfo";

const String postCreateInvitationsEndPoint = "/api/v1/invitation/create";

const String cancelInvitationVisitEndPoint = "/api/v1/invitation/cancle";
const String getInvitationByIDEndPoint = "/api/v1/invitation/get/";
const String getAreaUnitEndPoint = "/api/v1/area/unit";
