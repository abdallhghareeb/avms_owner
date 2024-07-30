
import 'package:avms/features/auth/domain/entities/register.dart';

class RegisterResponseModel extends RegisterResponse {
  RegisterResponseModel({
    required int statusCode,
    dynamic meta,
    required bool succeeded,
    required String message,
    dynamic errors,
    required RegisterDataModel data,
  }) : super(
    statusCode: statusCode,
    meta: meta,
    succeeded: succeeded,
    message: message,
    errors: errors,
    data: data,
  );

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      statusCode: json['statusCode'] ?? 0,
      meta: json['meta'],
      succeeded: json['succeeded'] ?? false,
      message: json['message'] ?? '',
      errors: json['errors'],
      data: RegisterDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'meta': meta,
      'succeeded': succeeded,
      'message': message,
      'errors': errors,
      'data': (data as RegisterDataModel).toJson(),
    };
  }
}

class RegisterDataModel extends RegisterData {
  RegisterDataModel({
    required String confirmMessage,
    String? token,
    required String expiresOn,
  }) : super(
    confirmMessage: confirmMessage,
    token: token,
    expiresOn: expiresOn,
  );

  factory RegisterDataModel.fromJson(Map<String, dynamic> json) {
    return RegisterDataModel(
      confirmMessage: json['confirmMessage'] ?? '',
      token: json['token'],
      expiresOn: json['expiresOn'] ?? '',
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
