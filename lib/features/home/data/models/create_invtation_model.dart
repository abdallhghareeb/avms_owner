class CreateInvitationModel {
  final int statusCode;
  final dynamic meta;
  final bool succeeded;
  final String message;
  final dynamic errors;
  final Data data;

  CreateInvitationModel({
    required this.statusCode,
    this.meta,
    required this.succeeded,
    required this.message,
    this.errors,
    required this.data,
  });

  // Factory method to create an instance from JSON
  factory CreateInvitationModel.fromJson(Map<String, dynamic> json) {
    return CreateInvitationModel(
      statusCode: json['statusCode'],
      meta: json['meta'],
      succeeded: json['succeeded'],
      message: json['message'],
      errors: json['errors'],
      data: Data.fromJson(json['data']),
    );
  }

  // Method to convert the instance to JSON
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

// Model for the 'data' field
class Data {
  final String qrLink;

  Data({
    required this.qrLink,
  });

  // Factory method to create an instance from JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      qrLink: json['qrLink'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'qrLink': qrLink,
    };
  }
}
