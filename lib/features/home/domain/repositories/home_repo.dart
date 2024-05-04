import 'package:avms/features/home/domain/entities/Qr.dart';
import 'package:avms/features/home/domain/entities/info.dart';
import 'package:avms/features/home/domain/entities/visit.dart';

abstract class HomeRepo {
  Future<Info> getDashInfo();

  Future<List<Visit>> getInvitationsVisit();

  Future<Qr> createInvitations({
    required String fullName,
    required String phone,
    required String email,
    required String nationalId,
    required DateTime registerDate,
    required DateTime expiredDate,
    String? documentImage,
    String? cardNumber,
  });

  Future<Map<String, dynamic>> cancelInvitationVisit({
    required String canceledId,
  });

  Future<Visit> getByID({required String ID});
}
