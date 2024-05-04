import 'dart:developer';

import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/features/auth/data/models/user_model.dart';
import 'package:avms/features/auth/domain/entities/response.dart';

class AuthResponseModel extends AuthResponse {
  final dynamic data;

  AuthResponseModel({
    required int statusCode,
    required bool succeeded,
    required String message,
    required this.data,
    required dynamic meta,
    required dynamic errors,
  }) : super(
    statusCode: statusCode,
    succeeded: succeeded,
    message: message,
    meta: meta,
    errors: errors,
  );

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      statusCode: json['statusCode'] as int,
      meta: json['meta'],
      succeeded: json['succeeded'] as bool,
      message: json['message'] as String,
      errors: json['errors'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'meta': meta,
      'succeeded': succeeded,
      'message': message,
      'errors': errors,
      'data': data is UserModel ? (data as UserModel).toJson() : data,
    };
  }
}
