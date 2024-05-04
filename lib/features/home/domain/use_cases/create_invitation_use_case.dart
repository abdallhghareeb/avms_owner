import 'package:avms/features/home/domain/entities/Qr.dart';
import 'package:avms/features/home/domain/entities/visit.dart';
import 'package:avms/features/home/domain/repositories/home_repo.dart';
import 'package:flutter/cupertino.dart';

class CreateInvitationUseCase {
  final HomeRepo homeRepo;

  CreateInvitationUseCase({required this.homeRepo});

  Future<Qr> execute({
    required String fullName,
    required String phone,
    required String email,
    required String nationalId,
    required DateTime registerDate,
    required DateTime expiredDate,
  }) {
    return homeRepo.createInvitations(
        fullName: fullName,
        phone: phone,
        email: email,
        nationalId: nationalId,
        registerDate: registerDate,
        expiredDate: expiredDate,

    );
  }
}
