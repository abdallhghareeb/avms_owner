import 'package:avms/features/auth/domain/entities/user.dart';
import 'package:avms/features/auth/domain/repositories/auth_repo.dart';

class SignInUseCase {
  final AuthRepo authRepo;

  SignInUseCase({required this.authRepo});

  Future<User?> execute(
    String userName,
    String password,
    String uniqCode,

  ) {
    return authRepo.signIn(
      userName: userName,
      password: password,
      uniqCode: uniqCode,
    );
  }
}
