import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/exceptions.dart';
import 'package:avms/features/auth/data/models/auth_response_model.dart';
import 'package:avms/features/auth/data/models/user_model.dart';
import 'package:avms/features/auth/domain/entities/response.dart';
import 'package:avms/features/auth/domain/entities/user.dart';
import 'package:avms/features/auth/domain/repositories/auth_repo.dart';
import 'package:avms/features/auth/presentation/screens/login_screen.dart';
import 'package:avms/features/splash/splash_screen.dart';
import 'package:avms/services/api_service/dio_helper.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/services/local/cache_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class AuthRepoImpl extends AuthRepo {
  @override
  Future<User?> signIn({
    required String userName,
    required String password,
    required String uniqCode,
  }) async {
    final signInParametersBody = {
      "username": userName,
      "password": password,
      "uniqCode": uniqCode,
    };

    var res = await handleRequest(() =>
        DioHelper.postSignIn(
          url: BASE_URL + postSignInEndPoint,
          parameters: signInParametersBody,
        ));
    // final authResponse = AuthResponseModel.fromJson(res);
    return UserModel.fromJson(res.data);
    // return null;
  }

  @override
  Future<void> signOut({required BuildContext context}) async {
    _clearCache();
    // Navigator.pop(context);
    PersistentNavBarNavigator.pushDynamicScreen(
        context, screen: MaterialPageRoute(builder: (context) => LoginScreen()),
        withNavBar: false);

    // Navigator.of(context).popUntil(ModalRoute.withName(LoginScreen.route));
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await DioHelper.postForgetPassword(
      url: BASE_URL + postForgetPasswordEndPoint,
      parameters: {
        "email": email,
      },
    );
  }

  @override
  Future<void> resetPassword({
    required String code,
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await handleRequest(() =>
        DioHelper.postResetPassword(
          url: BASE_URL + postResetPasswordEndPoint,
          parameters: {
            "resetCode": code,
            "email": email,
            "newPassword": newPassword,
            "confirmPassword": confirmPassword,
          },
        ));
    ;
  }
  Future<User?> signUp({
    required String userName,
    required String phone,
    required String uniqCode,
    required String email,
    required String AreaIds

  }) async {
    final signUpParametersBody = {
      "Username": userName,
      "PhoneNumber": phone,
      "UniqCode": uniqCode,
      "Email":email,
      "AreaIds":AreaIds
    };

    var res = await handleRequest(() =>
        DioHelper.postSignIn(
          url: BASE_URL + postSignUpEndPoint,
          parameters: signUpParametersBody,
        ));
    // final authResponse = AuthResponseModel.fromJson(res);
    return UserModel.fromJson(res.data);
    // return null;
  }

  void _clearCache() async {
    // await CacheHelper.removeData(key: CacheHelper.isLoginBeforeKey);
    // await CacheHelper.removeData(key: CacheHelper.userNameKey);
    // await CacheHelper.removeData(key: CacheHelper.userTokenKey);

    await CacheHelper.clear();
  }
}
