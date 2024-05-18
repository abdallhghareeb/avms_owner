import 'dart:io';
import 'package:avms/app.dart';
import 'package:avms/core/bloc/internet_cubit/internet_cubit.dart';
import 'package:avms/core/utils/bloc_observer.dart';
import 'package:avms/core/di/di.dart';
import 'package:avms/core/utils/config.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/auth/presentation/cubit/register_cubit/reg_cubit.dart';
import 'package:avms/features/auth/presentation/screens/enter_your_baseUrl.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/cubit/lang_cubit.dart';
import 'package:avms/helpers/Localization.dart';
import 'package:avms/services/api_service/api_server.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/services/local/cache_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/api_service/dio_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref= await SharedPreferences.getInstance();
  String lang=pref.getString('lang')??'en';
  String textLang=pref.getString('text')??'en';
  ConfigScreen.saveUrl=pref.getString('apiURL')??'http://egydns.ddns.net:2599/api/v1/';

  print(ConfigScreen.saveUrl);

  await Config.loadLanguage(lang);
  await Config.textChange(textLang);
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await DioHelper.init();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();


  HttpOverrides.global = MyHttpOverrides();
  setupLocator();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    EasyLocalization(
      supportedLocales: Localization.locales,
      path: 'assets/translation',
      fallbackLocale: Localization.defaultLocale,
      startLocale: Localization.defaultLocale,
      saveLocale: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context)=>RegCubit(ApiServer())),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              signInUseCase: sl(),
              signUpUseCase: sl(),
              signOutUseCase: sl(),
              forgotPasswordUseCase: sl(),
              resetPasswordUseCase: sl(),
            ),
          ),
          BlocProvider<HomeCubit>(
            create: (context) => HomeCubit(
                dashInfoUseCase: sl(),
                getInvitationUseCase: sl(),
                createInvitationUseCase: sl(),
                cancelInvitationUseCase: sl(),
                getInvitationByIdUseCase: sl()),
          ),
          BlocProvider<LangCubit>(create: (context)=>LangCubit())

        ],
        child: AvmsApp(),
      ),
    ),
  );
}
