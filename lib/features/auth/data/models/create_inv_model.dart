class CreateInvModel {
  final int statusCode;
  final dynamic meta;
  final bool succeeded;
  final String message;
  final dynamic errors;
  final Data data;

  CreateInvModel({
    required this.statusCode,
    this.meta,
    required this.succeeded,
    required this.message,
    this.errors,
    required this.data,
  });

  // Factory constructor to create an ApiResponse instance from JSON
  factory CreateInvModel.fromJson(Map<String, dynamic> json) {
    return CreateInvModel(
      statusCode: json['statusCode'],
      meta: json['meta'],
      succeeded: json['succeeded'],
      message: json['message'],
      errors: json['errors'],
      data: Data.fromJson(json['data']),
    );
  }

  // Method to convert ApiResponse instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'meta': meta,
      'succeeded': succeeded,
      'message': message,
      'errors': errors,
      'data': data.toJson(),
    };
  }
}

// Define a class to represent the 'data' part of the response
class Data {
  final String qrLink;

  Data({
    required this.qrLink,
  });

  // Factory constructor to create a Data instance from JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      qrLink: json['qrLink'],
    );
  }

  // Method to convert Data instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'qrLink': qrLink,
    };
  }
}