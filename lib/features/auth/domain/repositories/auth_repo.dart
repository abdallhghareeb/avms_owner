import 'package:avms/features/auth/data/models/area_unit.dart';
import 'package:avms/features/auth/data/models/reg_model.dart';
import 'package:avms/features/auth/data/models/register_model.dart';
import 'package:avms/features/auth/domain/entities/register.dart';
import 'package:avms/features/auth/domain/entities/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

abstract class AuthRepo {
  Future<User?> signIn({
    required String userName,
    required String password,
    required String uniqCode
  });
  Future<RegisterModel?> signUp({
    required String userName,
    required String phone,
    required String uniqCode,
    required String email,
    required String AreaIds,
    required String roles,
     XFile file


  });
 // Future<Area> getAreaUnit();

  Future<void> signOut({required BuildContext context});

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String code,
    required String email,
    required String newPassword,
    required String confirmPassword,
  });
}
