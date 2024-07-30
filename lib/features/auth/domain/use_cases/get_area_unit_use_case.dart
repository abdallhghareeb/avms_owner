import 'package:avms/features/auth/data/models/area_unit.dart';
import 'package:avms/features/auth/domain/repositories/auth_repo.dart';

class GetAreaUnitUseCase {
  final AuthRepo authRepo;

  GetAreaUnitUseCase({required this.authRepo});

  Future<AreaResponse?> execute() {
    return authRepo.getAreaUnit();
  }
}
