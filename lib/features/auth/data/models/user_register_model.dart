import 'package:avms/features/auth/data/models/user_register.dart';

class UserRegisterModel extends UserRegister {
  UserRegisterModel({
    required int statusCode,
    required dynamic meta,
    required bool succeeded,
    required String message,
    dynamic errors,
    dynamic data,
  }) : super(
    statusCode: statusCode,
    meta: meta,
    succeeded: succeeded,
    message: message,
    errors: errors,
    data: data,
  );

  factory UserRegisterModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterModel(
      statusCode: json['StatusCode'] as int,
      meta: json['Meta'],
      succeeded: json['Succeeded'] as bool,
      message: json['Message'] as String,
      errors: json['Errors'],
      data: json['Data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StatusCode': statusCode,
      'Meta': meta,
      'Succeeded': succeeded,
      'Message': message,
      'Errors': errors,
      'Data': data,
    };
  }
}
