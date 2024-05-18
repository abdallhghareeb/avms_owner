import 'package:avms/features/auth/domain/entities/user.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthRepo {
  Future<User?> signIn({
    required String userName,
    required String password,
    required String uniqCode,
  });
  Future<User?> signUp({
    required String userName,
    required String phone,
    required String uniqCode,
    required String email,
    required String AreaIds,

  });

  Future<void> signOut({required BuildContext context});

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String code,
    required String email,
    required String newPassword,
    required String confirmPassword,
  });
}
