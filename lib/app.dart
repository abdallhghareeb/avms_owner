
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/core/utils/app_themes.dart';
import 'package:./avms/features/auth/presentation/screens/Area.dart';
import 'package:avms/features/auth/presentation/screens/area_unit_without_owner.dart';
import 'package:avms/features/auth/presentation/screens/enter_your_baseUrl.dart';
import 'package:avms/features/auth/presentation/screens/login_screen.dart';
import 'package:avms/features/auth/presentation/screens/register_screen.dart';
import 'package:avms/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:avms/features/home/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:avms/features/home/presentation/screens/home_screen.dart';
import 'package:avms/features/home/presentation/screens/invitation/invitations.dart';
import 'package:avms/features/home/presentation/screens/more_setting/appearance/apearance_screen.dart';
import 'package:avms/features/home/presentation/screens/more_setting/profile/profile_screen.dart';
import 'package:avms/features/home/presentation/screens/more_setting/update_profile/users_update_screen.dart';
import 'package:avms/features/splash/splash_screen.dart';
import 'package:avms/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AvmsApp extends StatefulWidget {
  const AvmsApp({Key? key}) : super(key: key);

  @override
  State<AvmsApp> createState() => _AvmsAppState();
}

class _AvmsAppState extends State<AvmsApp> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ScreenUtilInit(
      designSize: SizeConfig.screenSize!,
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            scaffoldMessengerKey: ScaffoldGlobalKey,
            // localizationsDelegates: [
            //   AppLocale.delegate,
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate
            // ],
            // supportedLocales: [
            //   Locale("en", ""),
            //   Locale("ar", ""),
            // ],
            //
            // localeResolutionCallback: (currentLang, supportLang) {
            //   if (currentLang != null) {
            //     for (Locale locale in supportLang) {
            //       if (locale.languageCode == currentLang.languageCode) {
            //         mySharedPreferences.setString("lang",currentLang.languageCode) ;
            //         return currentLang;
            //       }
            //     }
            //   }
            //   return supportLang.first;
            // },
            theme: AppThemes.lightTheme,
            home: SplashScreen(),

          );
        },
      ),
    );
  }
}
