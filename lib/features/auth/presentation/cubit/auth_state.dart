import 'package:avms/features/auth/domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String errorMessage;

  AuthError(this.errorMessage);
}

class AuthForgotPasswordLoading extends AuthState {}

class AuthForgotPasswordSuccess extends AuthState {
  final String recoveryEmail;

  AuthForgotPasswordSuccess(this.recoveryEmail);
}

class AuthAuthForgotPasswordError extends AuthState {
  final String errorMessage;

  AuthAuthForgotPasswordError(this.errorMessage);
}

class AuthResetPasswordLoading extends AuthState {}

class AuthResetPasswordSuccess extends AuthState {
  // final String recoveryEmail;

  // AuthResetPasswordSuccess(this.recoveryEmail);
}

class AuthAuthResetPasswordError extends AuthState {
  final String errorMessage;

  AuthAuthResetPasswordError(this.errorMessage);
}

class AuthSignOutLoading extends AuthState {}

class AuthSignOutSuccess extends AuthState {}

class AuthSignOutError extends AuthState {
  final String errorMessage;

  AuthSignOutError(this.errorMessage);
}
