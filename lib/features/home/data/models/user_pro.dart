class User {
  final String userId;
  final String username;
  final String email;
  final bool isActive;
  final String pictureUrl;
  final List<String> roles;
  final String accountStatus;
  final bool emailConfirmed;
  final String? phoneNumber; // Nullable field
  final bool isDeleted;
  final String? uniqCode; // Nullable field
  final String? createdUserId; // Nullable field
  final String? createdUserName; // Nullable field
  final String lastUpdatedUserId;
  final String updatedUserName;
  final String? deletedUserId; // Nullable field
  final String? deletedUserName; // Nullable field
  final List<dynamic> areas; // Assuming areas can contain different types

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.isActive,
    required this.pictureUrl,
    required this.roles,
    required this.accountStatus,
    required this.emailConfirmed,
    this.phoneNumber,
    required this.isDeleted,
    this.uniqCode,
    this.createdUserId,
    this.createdUserName,
    required this.lastUpdatedUserId,
    required this.updatedUserName,
    this.deletedUserId,
    this.deletedUserName,
    required this.areas,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      email: json['email'],
      isActive: json['isActive'],
      pictureUrl: json['pictureUrl'] ?? '',
      roles: List<String>.from(json['roles']),
      accountStatus: json['accountStatus'],
      emailConfirmed: json['emailConfirmed'],
      phoneNumber: json['phoneNumber'], // Ensure phoneNumber is nullable in JSON and model
      isDeleted: json['isDeleted'],
      uniqCode: json['uniqCode'],
      createdUserId: json['createdUserId'],
      createdUserName: json['createdUserName'],
      lastUpdatedUserId: json['lastUpdatedUserId'],
      updatedUserName: json['updatedUserName'],
      deletedUserId: json['deletedUserId'],
      deletedUserName: json['deletedUserName'],
      areas: json['areas'] != null ? List<dynamic>.from(json['areas']) : [],
    );
  }
}
