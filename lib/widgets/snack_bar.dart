import 'package:avms/core/utils/app_color.dart';
import 'package:avms/core/utils/app_conts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:avms/core/utils/app_themes.dart';

class SnackBarGlobal {
  static void show(
      {required String message, Color? color, Duration? duration}) {
    ScaffoldGlobalKey.currentState!
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor: color ?? Colors.red,
          duration: duration ?? const Duration(seconds: 3),
          elevation: 7,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                12,
              ),
            ),
          ),
          content: Text(
            message.tr(),
            style: AppThemes.lightTheme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
  }
}
