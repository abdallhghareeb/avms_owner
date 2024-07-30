import 'package:avms/features/auth/data/models/reg_model.dart';
import 'package:avms/features/auth/data/models/register_model.dart';
import 'package:avms/features/auth/domain/entities/register.dart';
import 'package:avms/features/auth/domain/entities/user.dart';
import 'package:avms/features/auth/domain/repositories/auth_repo.dart';

class SignUpUseCase {
  final AuthRepo authRepo;

  SignUpUseCase({required this.authRepo});

  Future<RegisterModel?> execute(
      dynamic userName,
      dynamic phone,
      dynamic uniqCode,
      dynamic email,dynamic AreaIds,dynamic roles,
      dynamic file


      ) {
    return authRepo.signUp(
      userName: userName,
      phone: phone,
      uniqCode: uniqCode,
      email: email,
      AreaIds: AreaIds,
      roles: roles, file:file
    );
  }
}
