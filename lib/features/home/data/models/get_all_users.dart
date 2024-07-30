class GetUserModel {
  final String userId;
  final String username;
  final String email;
  final bool isActive;
  final String pictureUrl;
  final List<String> roles;
  late final String accountStatus;
  final bool emailConfirmed;
  final String phoneNumber;
  final bool isDeleted;
  final String? uniqCode;
  final String? createdUserId;
  final String? createdUserName;
  final String? lastUpdatedUserId;
  final String? updatedUserName;
  final String? deletedUserId;
  final String? deletedUserName;
  final List<Map<String, dynamic>> areas;

  GetUserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.isActive,
    required this.pictureUrl,
    required this.roles,
    required this.accountStatus,
    required this.emailConfirmed,
    required this.phoneNumber,
    required this.isDeleted,
    this.uniqCode,
    this.createdUserId,
    this.createdUserName,
    this.lastUpdatedUserId,
    this.updatedUserName,
    this.deletedUserId,
    this.deletedUserName,
    required this.areas,
  });

  factory GetUserModel.fromJson(Map<String, dynamic> json) {
    return GetUserModel(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isActive: json['isActive'] ?? false,
      pictureUrl: json['pictureUrl'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      accountStatus: json['accountStatus'] ?? '',
      emailConfirmed: json['emailConfirmed'] ?? false,
      phoneNumber: json['phoneNumber'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      uniqCode: json['uniqCode'],
      createdUserId: json['createdUserId'],
      createdUserName: json['createdUserName'],
      lastUpdatedUserId: json['lastUpdatedUserId'],
      updatedUserName: json['updatedUserName'],
      deletedUserId: json['deletedUserId'],
      deletedUserName: json['deletedUserName'],
      areas: List<Map<String, dynamic>>.from(json['areas'] ?? []),
    );
  }
}
