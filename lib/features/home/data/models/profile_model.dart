class ProfileModel {
  String userId;
  String username;
  String email;
  bool isActive;
  String pictureUrl;
  List<String> roles;
  String accountStatus;
  bool emailConfirmed;
  String phoneNumber;
  bool isDeleted;
  String lastUpdatedUserId;
  String updatedUserName;
  List<Area> areas;

  ProfileModel({
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
    required this.lastUpdatedUserId,
    required this.updatedUserName,
    required this.areas,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['userId'],
      username: json['username'],
      email: json['email'],
      isActive: json['isActive'],
      pictureUrl: json['pictureUrl'],
      roles: List<String>.from(json['roles']),
      accountStatus: json['accountStatus'],
      emailConfirmed: json['emailConfirmed'],
      phoneNumber: json['phoneNumber'],
      isDeleted: json['isDeleted'],
      lastUpdatedUserId: json['lastUpdatedUserId'],
      updatedUserName: json['updatedUserName'],
      areas: (json['areas'] as List).map((area) => Area.fromJson(area)).toList(),
    );
  }
}

class Area {
  int id;
  String name;

  Area({
    required this.id,
    required this.name,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      name: json['name'],
    );
  }
}
