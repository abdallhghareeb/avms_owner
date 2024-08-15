
class CancelInvitationResponse {
  final int statusCode;
  final dynamic meta;
  final bool succeeded;
  final String message;
  final dynamic errors;
  final CancelInvitationData? data;

  CancelInvitationResponse({
    required this.statusCode,
    this.meta,
    required this.succeeded,
    required this.message,
    this.errors,
    this.data,
  });

  // Factory method to create an instance from JSON
  factory CancelInvitationResponse.fromJson(Map<String, dynamic> json) {
    return CancelInvitationResponse(
      statusCode: json['statusCode'],
      meta: json['meta'],
      succeeded: json['succeeded'],
      message: json['message'],
      errors: json['errors'],
      data: json['data'] != null
          ? CancelInvitationData.fromJson(json['data'])
          : null,
    );
  }

  // Method to convert an instance to JSON
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

class CancelInvitationData {
  final String registrationId;

  CancelInvitationData({
    required this.registrationId,
  });

  // Factory method to create an instance from JSON
  factory CancelInvitationData.fromJson(Map<String, dynamic> json) {
    return CancelInvitationData(
      registrationId: json['registrationId'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'registrationId': registrationId,
    };
  }
}
