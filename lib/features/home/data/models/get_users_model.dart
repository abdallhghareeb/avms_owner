// import 'dart:convert';
//
// class GetUsers {
//   final String userId;
//   final String username;
//   final String email;
//   final bool isActive;
//   final String pictureUrl;
//   final List<String> roles;
//   final String accountStatus;
//   final bool emailConfirmed;
//   final String phoneNumber;
//   final bool isDeleted;
//   final String? uniqCode;
//   final String? createdUserId;
//   final String? createdUserName;
//   final String? lastUpdatedUserId;
//   final String? updatedUserName;
//   final String? deletedUserId;
//   final String? deletedUserName;
//   final A areas;
//
//   GetUsers({
//     required this.userId,
//     required this.username,
//     required this.email,
//     required this.isActive,
//     required this.pictureUrl,
//     required this.roles,
//     required this.accountStatus,
//     required this.emailConfirmed,
//     required this.phoneNumber,
//     required this.isDeleted,
//     this.uniqCode,
//     this.createdUserId,
//     this.createdUserName,
//     this.lastUpdatedUserId,
//     this.updatedUserName,
//     this.deletedUserId,
//     this.deletedUserName,
//     required this.areas,
//   });
//
//   factory GetUsers.fromJson(Map<String, dynamic> json) {
//     return GetUsers(
//       userId: json['userId'],
//       username: json['username'],
//       email: json['email'],
//       isActive: json['isActive'],
//       pictureUrl: json['pictureUrl'],
//       roles: List<String>.from(json['roles']),
//       accountStatus: json['accountStatus'],
//       emailConfirmed: json['emailConfirmed'],
//       phoneNumber: json['phoneNumber'],
//       isDeleted: json['isDeleted'],
//       uniqCode: json['uniqCode'],
//       createdUserId: json['createdUserId'],
//       createdUserName: json['createdUserName'],
//       lastUpdatedUserId: json['lastUpdatedUserId'],
//       updatedUserName: json['updatedUserName'],
//       deletedUserId: json['deletedUserId'],
//       deletedUserName: json['deletedUserName'],
//       areas: (json['areas'] as List<dynamic>)
//           .map((e) => AreaUnit.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'username': username,
//       'email': email,
//       'isActive': isActive,
//       'pictureUrl': pictureUrl,
//       'roles': roles,
//       'accountStatus': accountStatus,
//       'emailConfirmed': emailConfirmed,
//       'phoneNumber': phoneNumber,
//       'isDeleted': isDeleted,
//       'uniqCode': uniqCode,
//       'createdUserId': createdUserId,
//       'createdUserName': createdUserName,
//       'lastUpdatedUserId': lastUpdatedUserId,
//       'updatedUserName': updatedUserName,
//       'deletedUserId': deletedUserId,
//       'deletedUserName': deletedUserName,
//       'areas': areas.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class AreaUnit {
//   final int id;
//   final String name;
//
//   AreaUnit({
//     required this.id,
//     required this.name,
//   });
//
//   factory AreaUnit.fromJson(Map<String, dynamic> json) {
//     return AreaUnit(
//       id: json['id'],
//       name: json['name'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//     };
//   }
// }
