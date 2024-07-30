import 'package:avms/features/auth/data/models/reg_model.dart';
import 'package:avms/features/auth/data/models/register_model.dart';
import 'package:avms/features/auth/domain/entities/register.dart';
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
class AuthLoading1 extends AuthState {}

class AuthAuthenticatedSignUp extends AuthState {
  final RegisterModel registerResponse;

  AuthAuthenticatedSignUp(this.registerResponse);
}

class AuthError1 extends AuthState {
  final String e;
  RegisterModel registerModel;
  AuthError1( this.e,this.registerModel);
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
class AuthAreaUnitLoading extends AuthState {}

class AuthAreaUnitSuccess extends AuthState {
  // final String recoveryEmail;

  // AuthResetPasswordSuccess(this.recoveryEmail);
}

class AuthAreaUnitError extends AuthState {
  final String errorMessage;

  AuthAreaUnitError(this.errorMessage);
}

class AuthSignOutLoading extends AuthState {}

class AuthSignOutSuccess extends AuthState {}

class AuthSignOutError extends AuthState {
  final String errorMessage;

  AuthSignOutError(this.errorMessage);
}
