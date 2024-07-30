const String BASE_URL = "http://";
String ?TokenSave;
String? save;
String ?RigisterSave;
String ?ResetPassSave;
String? ConfigSave;
bool? SaveNavToLoginWhenSaveApiUrl;
String ?saveEmail;
String?SaveApiUrl;
String ?SaveEmailForgetPass;
String ?SaveEmailRegisterToReset;
bool? forgetPassCheck;
bool?RegisterToResetCheck;
const String GetAll="/api/v1/area/get";
const String GetUnitWithId="/api/v1/area/unit?unit_id=";
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