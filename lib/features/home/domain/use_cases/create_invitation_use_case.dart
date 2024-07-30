import 'dart:io';

import 'package:avms/features/home/domain/entities/Qr.dart';
import 'package:avms/features/home/domain/entities/visit.dart';
import 'package:avms/features/home/domain/repositories/home_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

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
    required String AreaId,
    required String token,
    required XFile file,

  }) {
    return homeRepo.createInvitations(
        fullName: fullName,
        phone: phone,
        email: email,
        nationalId: nationalId,
        registerDate: registerDate,
        expiredDate: expiredDate,
      file: file, AreaId: AreaId,
      token: token

    );
  }
}
