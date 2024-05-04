import 'package:avms/features/auth/domain/repositories/auth_repo.dart';
import 'package:flutter/cupertino.dart';

class SignOutUseCase {
  final AuthRepo authRepo;

  SignOutUseCase({required this.authRepo});

  Future<void> execute({required BuildContext context}) {
    return authRepo.signOut(context: context);
  }
}

