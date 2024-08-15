// Example models (you should adjust these to match your actual JSON structure)

class InvitationData {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String documentId;
  final String cardNumber;
  final String areaNames;
  final int areaId;
  final String qrLink;
  final int invitDocType;
  final String name;
  final DateTime registrationDate;
  final DateTime expiryDate;
  final DateTime createDate;
  final String createdUserId;
  final String createdUserName;
  final String? lastUpdatedUserId;
  final String? updatedUserName;
  final bool isSuccess;
  final String documentImage;
  final String? transactionType;
  final String statusValue;

  InvitationData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.documentId,
    required this.cardNumber,
    required this.areaNames,
    required this.areaId,
    required this.qrLink,
    required this.invitDocType,
    required this.name,
    required this.registrationDate,
    required this.expiryDate,
    required this.createDate,
    required this.createdUserId,
    required this.createdUserName,
    this.lastUpdatedUserId,
    this.updatedUserName,
    required this.isSuccess,
    required this.documentImage,
    this.transactionType,
    required this.statusValue,
  });

  factory InvitationData.fromJson(Map<String, dynamic> json) {
    return InvitationData(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      documentId: json['documentId'],
      cardNumber: json['cardNumber'],
      areaNames: json['areaNames'],
      areaId: json['areaId'],
      qrLink: json['qrLink'],
      invitDocType: json['invitDocType'],
      name: json['name'],
      registrationDate: DateTime.parse(json['registrationDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      createDate: DateTime.parse(json['createDate']),
      createdUserId: json['createdUserId'],
      createdUserName: json['createdUserName'],
      lastUpdatedUserId: json['lastUpdatedUserId'],
      updatedUserName: json['updatedUserName'],
      isSuccess: json['isSuccess'],
      documentImage: json['documentImage'],
      transactionType: json['transactionType'],
      statusValue: json['statusValue'],
    );
  }
}

class InvitationResponse {
  final int statusCode;
  final bool succeeded;
  final String message;
  final List<InvitationData> data;
  final Meta meta;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  InvitationResponse({
    required this.statusCode,
    required this.succeeded,
    required this.message,
    required this.data,
    required this.meta,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory InvitationResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['data'] as List;
    List<InvitationData> invitationList = list.map((i) => InvitationData.fromJson(i)).toList();

    return InvitationResponse(
      statusCode: json['statusCode'],
      succeeded: json['succeeded'],
      message: json['message'],
      data: invitationList,
      meta: Meta.fromJson(json['data']['meta']),
      currentPage: json['data']['currentPage'],
      totalPages: json['data']['totalPages'],
      totalCount: json['data']['totalCount'],
      pageSize: json['data']['pageSize'],
      hasPreviousPage: json['data']['hasPreviousPage'],
      hasNextPage: json['data']['hasNextPage'],
    );
  }
}

class Meta {
  final int canceldCount;
  final int expiredCount;
  final int activeCount;
  final int success;
  final int successAndActiveCount;

  Meta({
    required this.canceldCount,
    required this.expiredCount,
    required this.activeCount,
    required this.success,
    required this.successAndActiveCount,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      canceldCount: json['canceldCount'],
      expiredCount: json['expiredCount'],
      activeCount: json['activeCount'],
      success: json['success'],
      successAndActiveCount: json['successAndActiveCount'],
    );
  }
}
