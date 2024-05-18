import 'package:avms/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:avms/features/auth/domain/repositories/auth_repo.dart';
import 'package:avms/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:avms/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:avms/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:avms/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:avms/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/home/data/repositories/home_repo_impl.dart';
import 'package:avms/features/home/domain/repositories/home_repo.dart';
import 'package:avms/features/home/domain/use_cases/cancel_invitation_use_case.dart';
import 'package:avms/features/home/domain/use_cases/create_invitation_use_case.dart';
import 'package:avms/features/home/domain/use_cases/get_dash_info_use_case.dart';
import 'package:avms/features/home/domain/use_cases/get_invitation_visits_use_case.dart';
import 'package:avms/features/home/domain/use_cases/get_invitstion_by_id_use_case.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void setupLocator() {
  // Register repositories
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl());
  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl());

  // Register UseCases
  sl.registerLazySingleton(() => SignInUseCase(authRepo: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(authRepo: sl()));

  sl.registerLazySingleton(() => SignOutUseCase(authRepo: sl()));
  sl.registerLazySingleton(() => ForgetPasswordUseCase(authRepo: sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(authRepo: sl()));

  sl.registerLazySingleton(() => GetDashInfoUseCase(homeRepo: sl()));
  sl.registerLazySingleton(() => GetInvitationVisitsUseCase(homeRepo: sl()));
  sl.registerLazySingleton(() => CreateInvitationUseCase(homeRepo: sl()));
  sl.registerLazySingleton(() => CancelInvitationUseCase(homeRepo: sl()));
  sl.registerLazySingleton(() => GetInvitationByIdUseCase(homeRepo: sl()));

  // Register Cubits
  sl.registerFactory(
    () => AuthCubit(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      forgotPasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => HomeCubit(
      dashInfoUseCase: sl(),
      getInvitationUseCase: sl(),
      createInvitationUseCase: sl(),
      cancelInvitationUseCase: sl(),
      getInvitationByIdUseCase: sl(),
    ),
  );
}
