import 'package:avms/features/auth/domain/repositories/auth_repo.dart';

class ResetPasswordUseCase {
  final AuthRepo authRepo;

  ResetPasswordUseCase({required this.authRepo});

  Future<void> execute({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) {
    return authRepo.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
        confirmPassword: confirmPassword);
  }
}
