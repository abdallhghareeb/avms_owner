
import 'package:avms/features/home/domain/entities/visit.dart';
import 'package:avms/features/home/domain/repositories/home_repo.dart';

class GetInvitationVisitsUseCase {
  final HomeRepo homeRepo;

  GetInvitationVisitsUseCase({required this.homeRepo});

  Future<List<Visit>> execute() {
    return homeRepo.getInvitationsVisit();
  }
}

