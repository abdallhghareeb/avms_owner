import 'package:avms/features/auth/domain/repositories/auth_repo.dart';

class ForgetPasswordUseCase {
  final AuthRepo authRepo;

  ForgetPasswordUseCase({required this.authRepo});

  Future<void> execute(String email) {
    return authRepo.forgotPassword(email: email);
  }
}
