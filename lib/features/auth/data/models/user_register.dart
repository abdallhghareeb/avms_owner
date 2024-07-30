import 'package:equatable/equatable.dart';

class UserRegister extends Equatable {
  final int statusCode;
  final dynamic meta;
  final bool succeeded;
  final String message;
  final dynamic errors;
  final dynamic data;

  UserRegister({
    required this.statusCode,
    required this.meta,
    required this.succeeded,
    required this.message,
    this.errors,
    this.data,
  });

  @override
  List<Object?> get props => [
    statusCode,
    meta,
    succeeded,
    message,
    errors,
    data,
  ];

  @override
  String toString() {
    return 'User{statusCode: $statusCode, meta: $meta, succeeded: $succeeded, message: $message, errors: $errors, data: $data}';
  }
}
