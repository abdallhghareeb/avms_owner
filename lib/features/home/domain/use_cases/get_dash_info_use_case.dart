
import 'package:avms/features/home/domain/entities/info.dart';
import 'package:avms/features/home/domain/repositories/home_repo.dart';

class GetDashInfoUseCase {
  final HomeRepo homeRepo;

  GetDashInfoUseCase({required this.homeRepo});

  Future<Info?> execute() {
    return homeRepo.getDashInfo();
  }
}
