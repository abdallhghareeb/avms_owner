import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:avms/features/auth/data/models/reg_model.dart';
import 'package:avms/features/auth/data/models/register_model.dart';
import 'package:avms/features/auth/domain/entities/register.dart';
import 'package:avms/features/auth/domain/entities/user.dart';
import 'package:avms/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:avms/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:avms/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:avms/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:avms/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:avms/features/auth/presentation/cubit/auth_state.dart';
import 'package:avms/services/api_service/dio_helper.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/services/local/cache_helper.dart';
import 'package:avms/services/local/dio_helper.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
  RegisterModel ?registerResponse;

  Future<void> signIn(String email, String password,String uniqCode) async {
    emit(AuthLoading());

    try {
      final user = await Future.any([
        signInUseCase.execute(email, password,uniqCode),
        Future.delayed(Duration(seconds: 15), () {
          throw TimeoutException('Sign-in timed out');
        }),
      ]);

      if (user != null) {
        await _cacheData(user);
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError(''));
      }
    } on TimeoutException catch (e) {
      log('Sign-in timeout: ${e.message}');
      emit(AuthError(e.message!));
    } catch (e) {
      log('An error occurred: ${e.toString()}');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp({
    required String email,
    required String phone,
    required String name,
    required String uni,
    required String area,
    required String roles,
    XFile? file,
  }) async {
    emit(AuthLoading1());
    var formData = FormData.fromMap({
      "Username": name,
      "PhoneNumber": phone,
      "UniqCode": uni,
      "Email":email,
      "AreaIds":area,
      "Roles":roles,
      "Image": await MultipartFile.fromFile(file!.path, filename: file.path.split('/').last)??'',
    });
    DioHelper.postSignUp(url: '$BASE_URL$SaveApiUrl$postSignUpEndPoint',parameters:formData ).then((value){

      registerResponse=  RegisterModel.fromJson(value.data);
      print(registerResponse?.message);
      print(registerResponse?.statusCode);
      print(registerResponse!.data!.token);
      emit(AuthAuthenticatedSignUp(registerResponse!));
    }).catchError((e){
      emit(AuthError1(e.toString(),registerResponse!));
      print( e.toString());
    });

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
  // String? valueBase;
  // void putYourBaseUrl(String value)async{
  //   SharedPreferences pre= await SharedPreferences.getInstance();
  //   valueBase=value;
  //   BASE_URL=value;
  //   pre.setString('baseUrl', '$BASE_URL}');
  //
  // }
}
