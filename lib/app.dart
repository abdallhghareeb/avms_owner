
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:avms/core/utils/app_themes.dart';
import 'package:avms/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppThemes.lightTheme,
            routes: routes,
          );
        },
      ),
    );
  }
}
