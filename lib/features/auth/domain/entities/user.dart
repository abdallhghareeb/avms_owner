import 'package:equatable/equatable.dart';

class User extends Equatable {
  final dynamic message;
  final bool? isAuthenticated;
  final dynamic username;
  final dynamic email;
  final List<dynamic>? roles;
  final dynamic token;
  final String? expiresOn;
  final String? refreshTokenExpiration;

  User({
    required this.message,
    required this.isAuthenticated,
    required this.username,
    required this.email,
    required this.roles,
    required this.token,
    required this.expiresOn,
    required this.refreshTokenExpiration,
  });

  @override
  List<Object?> get props => [
        message,
        isAuthenticated,
        username,
        email,
        roles,
        token,
        expiresOn,
        refreshTokenExpiration,
      ];

  @override
  String toString() {
    return 'User{message: $message, isAuthenticated: $isAuthenticated, username: $username, email: $email, roles: $roles, token: $token, expiresOn: $expiresOn, refreshTokenExpiration: $refreshTokenExpiration}';
  }
}
