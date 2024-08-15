import 'package:avms/features/home/data/models/document_type.dart';

class ApiResponse {
  final int statusCode;
  final String? meta;
  final bool succeeded;
  final String message;
  final String? errors;
  final List<DocumentType> data;

  ApiResponse({
    required this.statusCode,
    this.meta,
    required this.succeeded,
    required this.message,
    this.errors,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['statusCode'],
      meta: json['meta'],
      succeeded: json['succeeded'],
      message: json['message'],
      errors: json['errors'],
      data: List<DocumentType>.from(
        json['data'].map((x) => DocumentType.fromJson(x)),
      ),
    );
  }
}
