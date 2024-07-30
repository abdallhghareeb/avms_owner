class CreateInvitationResponse {
  final int statusCode;
  final dynamic meta;
  final bool succeeded;
  final String message;
  final dynamic errors;
  final CreateInvitationData data;

  CreateInvitationResponse({
    required this.statusCode,
    required this.meta,
    required this.succeeded,
    required this.message,
    required this.errors,
    required this.data,
  });

  factory CreateInvitationResponse.fromJson(Map<String, dynamic> json) {
    return CreateInvitationResponse(
      statusCode: json['statusCode'],
      meta: json['meta'],
      succeeded: json['succeeded'],
      message: json['message'],
      errors: json['errors'],
      data: CreateInvitationData.fromJson(json['data']),
    );
  }
}

class CreateInvitationData {
  final String qrLink;

  CreateInvitationData({required this.qrLink});

  factory CreateInvitationData.fromJson(Map<String, dynamic> json) {
    return CreateInvitationData(
      qrLink: json['qrLink'],
    );
  }
}
