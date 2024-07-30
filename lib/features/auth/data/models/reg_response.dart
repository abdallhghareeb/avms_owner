class RegisterResponse {
  final int statusCode;
  final bool succeeded;
  final String message;
  final Data data;

  RegisterResponse({
    required this.statusCode,
    required this.succeeded,
    required this.message,
    required this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      statusCode: json['statusCode'],
      succeeded: json['succeeded'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final String confirmMessage;

  Data({
    required this.confirmMessage,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      confirmMessage: json['confirmMessage'],
    );
  }
}
