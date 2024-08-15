class LoginModel {
  final int statusCode;
  final dynamic meta;
  final bool succeeded;
  final String message;
  final dynamic errors;
  final Data? data; // Make data optional

  LoginModel({
    required this.statusCode,
    this.meta,
    required this.succeeded,
    required this.message,
    this.errors,
    this.data, // Optional
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      statusCode: json['statusCode'],
      meta: json['meta'],
      succeeded: json['succeeded'],
      message: json['message'],
      errors: json['errors'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null, // Handle null case
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'meta': meta,
      'succeeded': succeeded,
      'message': message,
      'errors': errors,
      'data': data?.toJson(), // Handle null case
    };
  }
}


class Data {
  final String? confirmMessage;
  final String? token; // Optional
  final String? expiresOn; // Optional

  Data({
    this.confirmMessage,
    this.token,
    this.expiresOn,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      confirmMessage: json['confirmMessage'],
      token: json['token'],
      expiresOn: json['expiresOn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'confirmMessage': confirmMessage,
      'token': token,
      'expiresOn': expiresOn,
    };
  }
}
