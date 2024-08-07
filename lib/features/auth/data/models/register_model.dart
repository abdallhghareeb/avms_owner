class RegisterModel {
  int statusCode;
  dynamic meta;
  bool succeeded;
  String message;
  dynamic errors;
  Data? data;

  RegisterModel({
    required this.statusCode,
    this.meta,
    required this.succeeded,
    required this.message,
    this.errors,
    this.data,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      statusCode: json['statusCode'],
      meta: json['meta'],
      succeeded: json['succeeded'],
      message: json['message'],
      errors: json['errors'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  String confirmMessage;
  String? token;
  String expiresOn;

  Data({
    required this.confirmMessage,
    this.token,
    required this.expiresOn,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      confirmMessage: json['confirmMessage'],
      token: json['token'],
      expiresOn: json['expiresOn'],
    );
  }
}
