import 'package:equatable/equatable.dart';

class ErrorResponse extends Equatable {
  final int? statusCode;
  final dynamic meta;
  final bool? succeeded;
  final String? message;
  final dynamic errors;
  final dynamic data;

  ErrorResponse({
    required this.statusCode,
    required this.meta,
    required this.succeeded,
    required this.message,
    required this.errors,
    required this.data,
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
    return 'ErrorResponse{statusCode: $statusCode, meta: $meta, succeeded: $succeeded, message: $message, errors: $errors, data: $data}';
  }
}
