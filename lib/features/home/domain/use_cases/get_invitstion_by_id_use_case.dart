import 'package:avms/features/home/domain/entities/Qr.dart';
import 'package:avms/features/home/domain/entities/visit.dart';
import 'package:avms/features/home/domain/repositories/home_repo.dart';
import 'package:flutter/cupertino.dart';

class GetInvitationByIdUseCase {
  final HomeRepo homeRepo;

  GetInvitationByIdUseCase({required this.homeRepo});

  Future<Visit> execute({
    required String invitationId,
  }) {
    return homeRepo.getByID(
      ID: invitationId,
    );
  }
}
