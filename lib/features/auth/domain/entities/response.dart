import 'package:avms/features/auth/data/models/user_model.dart';
import 'package:avms/features/auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final int? statusCode;
  final dynamic meta;
  final bool? succeeded;
  final dynamic message;
  final dynamic errors;
  // final dynamic data;

  AuthResponse({
    required this.statusCode,
    required this.meta,
    required this.succeeded,
    required this.message,
    required this.errors,
    // required this.data,
  });

  @override
  List<Object?> get props => [
        statusCode,
        meta,
        succeeded,
        message,
        errors,
        // data,
      ];

  @override
  String toString() {
    return 'AuthResponse{statusCode: $statusCode, meta: $meta, succeeded: $succeeded, message: $message, errors: $errors}';
  }
}
