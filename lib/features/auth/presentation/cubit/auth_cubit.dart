import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:avms/features/auth/data/models/login_model.dart';
import 'package:avms/features/auth/data/models/register_model.dart';
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
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
  LoginModel ?loginModel;

  Future<void> login(String email, String password, String uniqCode) async {
    emit(AuthLoading());

    try {
      final response = await DioHelper.postSignIn(
        url: '$BASE_URL$SaveApiUrl$postSignInEndPoint',
        parameters: {
          'username': email,
          'password': password,
          //'uniqCode': uniqCode,
        },
      );

      if (response.statusCode == 200) {
         loginModel = LoginModel.fromJson(response.data);
         await _cacheData(loginModel!);
        emit(AuthAuthenticated(loginModel!));
       } else {
        // Handle non-200 responses
        final errorResponse = LoginModel.fromJson(response.data);
        emit(AuthError('Failed to login: ${errorResponse.message}', errorResponse));
      }
    } on DioError catch (e) {
      if (e.response != null) {
        try {
          // Attempt to parse the error response
          final errorResponse = LoginModel.fromJson(e.response!.data);

          emit(AuthError('API error: ${errorResponse.message}', errorResponse));
        } catch (jsonError) {
          // Handle JSON parsing errors
          emit(AuthError('Failed to parse error response: ${e.response?.statusMessage ?? 'Unknown error'}', LoginModel(
            statusCode: 0,
            succeeded: false,
            message: 'Failed to parse error response',
            data: null,
          )));
        }
      } else {
        // Handle network errors
        emit(AuthError('Network error: ${e.message}', LoginModel(
          statusCode: 0,
          succeeded: false,
          message: 'Network error',
          data: null,
        )));
      }
    } catch (e) {
      emit(AuthError('Unexpected error: $e', LoginModel(
        statusCode: 0,
        succeeded: false,
        message: 'Username or Password is incorrect!',
        data: null,
      )));
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

    try {
      MultipartFile? imageFile;
      if (file != null) {
        imageFile = await MultipartFile.fromFile(file.path, filename: file.path.split('/').last);
      }

      var formData = FormData.fromMap({
        "Username": name,
        "PhoneNumber": phone,
        "UniqCode": uni,
        "Email": email,
        "AreaIds": area,
        "Roles": roles,
        "Image": imageFile ?? '', // Handle null case
      });

      // Making the POST request
      var response = await DioHelper.postSignUp(
        url: '$BASE_URL$SaveApiUrl$postSignUpEndPoint',
        parameters: formData,
      );

      // Parse the response
      if (response.data != null) {
        registerResponse = RegisterModel.fromJson(response.data);

        if (registerResponse?.statusCode == 200) {
          print(registerResponse?.message);
          print(registerResponse?.statusCode);
          print(registerResponse?.data?.confirmMessage);
          emit(AuthAuthenticatedSignUp(registerResponse!));
        } else {
          // Handle error response
          emit(AuthError1(registerResponse?.message ?? 'Unknown error', registerResponse!));
        }
      } else {
        emit(AuthError1('Received null response from server', registerResponse ?? RegisterModel(statusCode: 500, succeeded: false, message: 'Received null response from server')));
      }
    } catch (e) {
      String errorMessage = 'Unexpected error';
      if (e is DioError) {
        if (e.response != null && e.response?.data != null) {
          // Extract error message from API response
          var errorData = e.response?.data;
          if (errorData is Map<String, dynamic>) {
            errorMessage = errorData['Message'] ?? 'validation error, please chick you data';
          } else {
            errorMessage = 'Unexpected error format';
          }
        } else {
          // Network errors or other types of DioErrors
          errorMessage = 'Network error: ${e.message}';
        }
      } else {
        // Handle any other type of error
        errorMessage = 'Unexpected error: ${e.toString()}';
      }

      // Ensure registerResponse is not null before using it
      emit(AuthError1(errorMessage, registerResponse ?? RegisterModel(statusCode: 500, succeeded: false, message: errorMessage)));
      print(errorMessage);
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

      emit(AuthAuthForgotPasswordError(
          'Forgot password failed ${e.toString()}'));
    }
  }

  Future<void> _cacheData(LoginModel user) async {
    await CacheHelper.saveData(key: CacheHelper.emailKey, value: user.data!.confirmMessage);
    await CacheHelper.saveData(
        key: CacheHelper.userTokenKey, value: user.data!.token);

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
