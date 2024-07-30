import 'package:equatable/equatable.dart';

class RegisterResponse extends Equatable {
  final int statusCode;
  final dynamic meta;
  final bool succeeded;
  final String message;
  final dynamic errors;
  final RegisterData data;

  RegisterResponse({
    required this.statusCode,
    this.meta,
    required this.succeeded,
    required this.message,
    this.errors,
    required this.data,
  });

  @override
  List<Object?> get props => [statusCode, meta, succeeded, message, errors, data];

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      statusCode: json['statusCode'] ?? 0,
      meta: json['meta'],
      succeeded: json['succeeded'] ?? false,
      message: json['message'] ?? '',
      errors: json['errors'],
      data: RegisterData.fromJson(json['data'] ?? {}),
    );
  }
}
class RegisterData extends Equatable {
  final String confirmMessage;
  final String? token;
  final String expiresOn;

  RegisterData({
    required this.confirmMessage,
    this.token,
    required this.expiresOn,
  });

  @override
  List<Object?> get props => [confirmMessage, token, expiresOn];

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      confirmMessage: json['confirmMessage'] ?? '',
      token: json['token'],
      expiresOn: json['expiresOn'] ?? '',
    );
  }
}
