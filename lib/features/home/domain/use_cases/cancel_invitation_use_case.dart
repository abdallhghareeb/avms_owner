import 'package:avms/features/home/domain/entities/Qr.dart';
import 'package:avms/features/home/domain/entities/visit.dart';
import 'package:avms/features/home/domain/repositories/home_repo.dart';
import 'package:flutter/cupertino.dart';

class CancelInvitationUseCase {
  final HomeRepo homeRepo;

  CancelInvitationUseCase({required this.homeRepo});

  Future<Map<String, dynamic>> execute({
    required String canceledId,
  }) {
    return homeRepo.cancelInvitationVisit(
      canceledId: canceledId,
    );
  }
}
