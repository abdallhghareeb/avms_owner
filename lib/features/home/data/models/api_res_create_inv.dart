class ApiResponseToCreateInv {
  final int statusCode;
  final dynamic meta;
  final bool succeeded;
  final String message;
  final dynamic errors;
  final Data? data;

  ApiResponseToCreateInv({
    required this.statusCode,
    this.meta,
    required this.succeeded,
    required this.message,
    this.errors,
    this.data,
  });

  factory ApiResponseToCreateInv.fromJson(Map<String, dynamic> json) {
    return ApiResponseToCreateInv(
      statusCode: json['statusCode'] ?? 0,
      meta: json['meta'],
      succeeded: json['succeeded'] ?? false,
      message: json['message'] ?? 'No message',
      errors: json['errors'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'meta': meta,
      'succeeded': succeeded,
      'message': message,
      'errors': errors,
      'data': data?.toJson(),
    };
  }
}
class Data {
  final String qrLink;

  Data({
    required this.qrLink,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      qrLink: json['qrLink'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qrLink': qrLink,
    };
  }
}
