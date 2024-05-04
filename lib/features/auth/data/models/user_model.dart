import 'package:avms/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required dynamic message,
    required bool? isAuthenticated,
    required String? username,
    required String? email,
    required List<dynamic>? roles,
    required String? token,
    required String? expiresOn,
    required String? refreshTokenExpiration,
  }) : super(
    message: message,
    isAuthenticated: isAuthenticated,
    username: username,
    email: email,
    roles: roles,
    token: token,
    expiresOn: expiresOn,
    refreshTokenExpiration: refreshTokenExpiration,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      message: json['message'],
      isAuthenticated: json['isAuthenticated'] as bool?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      roles: json['roles'] != null ? List.from(json['roles']) : null,
      token: json['token'] as String?,
      expiresOn: json['expiresOn'] as String?,
      refreshTokenExpiration: json['refreshTokenExpiration'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'isAuthenticated': isAuthenticated,
      'username': username,
      'email': email,
      'roles': roles,
      'token': token,
      'expiresOn': expiresOn,
      'refreshTokenExpiration': refreshTokenExpiration,
    };
  }
}
