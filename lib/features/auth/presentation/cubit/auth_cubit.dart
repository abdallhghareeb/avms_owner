import 'dart:developer';
import 'dart:io';
import 'package:avms/features/auth/data/models/reg_model.dart';
import 'package:avms/features/auth/domain/entities/user.dart';
import 'package:avms/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:avms/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:avms/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:avms/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:avms/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:avms/features/auth/presentation/cubit/auth_state.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/services/local/cache_helper.dart';
import 'package:avms/services/local/dio_helper.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final ForgetPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  static AuthCubit get(context) => BlocProvider.of(context);

  AuthCubit({
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
    required this.signUpUseCase
  }) : super(AuthInitial());

  User? user;

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());

    try {
      user = await signInUseCase.execute(email, password, await getId());
      if (user != null) {
        await _cacheData(user!);
        emit(AuthAuthenticated(user!));
      } else {
        emit(AuthError('Authentication failed'));
      }
    } catch (e) {
      log("An error occurred ${e.toString()}");
      emit(AuthError('An error occurred ${e.toString()}'));
    }
  }
  RegModel ?regModel;
  void putReg({
    required String? Name,
    required String? Phone,
    required String? uni,
    required String? Email,
    required String areaId,
  }) async {
    // Check for null values
    if (Name == null || Name.isEmpty ||
        Phone == null || Phone.isEmpty ||
        uni == null || uni.isEmpty ||
        Email == null || Email.isEmpty ||
        areaId.isEmpty) {
      emit(AuthError1('All fields are required.'));
      return;
    }

    emit(AuthLoading1());

    try {
      // Make the API call
      final response = await DioHelper.postData(
        url: 'auth/register',
        data: {
          "Username": Name,
          "PhoneNumber": Phone,
          "UniqCode": uni,
          "Email": Email,
          "AreaIds": areaId,
        },
      );

      // Parse the response
      regModel = RegModel.fromJson(response.data);
      print('Status Code => ${regModel?.statusCode}');
      print('Status Message => ${regModel?.message}');
      print('Token => ${regModel?.data?.token}');

      emit(AuthAuthenticatedSignUp(regModel!));
    } catch (e) {
      // Check if the error is a DioError and handle accordingly
      emit(AuthError1('An error occurred: ${e.toString()}'));
    }
  }


  Future<void> forgotPassword(String email) async {
    emit(AuthForgotPasswordLoading());
    try {
      await forgotPasswordUseCase.execute(email);
      emit(AuthForgotPasswordSuccess(email));
    } catch (e) {
      log("e ${e.toString()}");
      emit(AuthAuthForgotPasswordError(
          'Forgot password failed ${e.toString()}'));
    }
  }

  Future<void> signOut({required BuildContext context}) async {
    emit(AuthSignOutLoading());

    try {
      await signOutUseCase.execute(context: context);
      emit(AuthSignOutSuccess());
    } catch (e) {
      emit(AuthSignOutError('Sign-out failed'));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthResetPasswordLoading());
    try {
      await resetPasswordUseCase.execute(
        email: email,
        code: code,
        newPassword: password,
        confirmPassword: confirmPassword,
      );
      emit(AuthResetPasswordSuccess());
    } catch (e) {
      log("e ${e.toString()}");
      emit(AuthAuthForgotPasswordError(
          'Forgot password failed ${e.toString()}'));
    }
  }

  Future<void> _cacheData(User user) async {
    await CacheHelper.saveData(key: CacheHelper.emailKey, value: user.email);
    await CacheHelper.saveData(
        key: CacheHelper.userTokenKey, value: user.token);

    await CacheHelper.saveData(key: CacheHelper.isLoginBeforeKey, value: 1);
  }

  Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return await androidDeviceInfo.androidId; // unique ID on Android
    } else {
      Exception("Error not found androidId");
      return 'Error';
    }
  }
  String? valueBase;
  void putYourBaseUrl(String value)async{
    SharedPreferences pre= await SharedPreferences.getInstance();
    valueBase=value;
    BASE_URL=value;
    pre.setString('baseUrl', '$BASE_URL}');

  }
}
