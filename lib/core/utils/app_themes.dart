import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: AppColors.primaryColor,
    fontFamily: AppStrings.fontFamily,
    useMaterial3: false,
    scaffoldBackgroundColor: AppColors.offWhite,
    appBarTheme: AppBarTheme(
      toolbarHeight: 100,
      titleSpacing: 0.0,
      backgroundColor: AppColors.offWhite,
      elevation: 0,
      centerTitle: true,
      // foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      // toolbarTextStyle: TextStyle( color: Colors.white, fontSize: 18),
      titleTextStyle: TextStyle(
        fontFamily: 'cairo',
        color: Colors.black,
        fontSize: 21,
      ),
    ),
  );
}
