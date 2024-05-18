import 'package:avms/features/auth/domain/entities/user.dart';
import 'package:avms/features/auth/domain/repositories/auth_repo.dart';

class SignUpUseCase {
  final AuthRepo authRepo;

  SignUpUseCase({required this.authRepo});

  Future<User?> execute(
      String userName,
      String phone,
      String uniqCode,
      String email,String AreaIds


      ) {
    return authRepo.signUp(
      userName: userName,
      phone: phone,
      uniqCode: uniqCode,
      email: email,
      AreaIds: AreaIds
    );
  }
}
