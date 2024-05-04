import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Localization {
  Localization._();

  static final locales = [
    const Locale('en'),
    const Locale('ar'),
  ];

  /// supported app languages
  static const languages = ['English', 'اللغة العربية'];

  static Locale get defaultLocale => locales.first;

  static String get defaultColumnLocale => 'Name_ar';

  /// change app locale
  static Future<void> changeLanguage(BuildContext context, String lang) async {
    await context.setLocale(locales[languages.indexOf(lang)]);
    //
    // await MyApp.setLocale(context, locales[languages.indexOf(lang)]);
  }

  /// gets current app locale
  static String currentLanguage(BuildContext context) {
    return languages[locales.indexOf(context.locale)];
    // return languages[locales.indexOf(MyApp.getLocale(context))];
  }

  /// columnLocale determines weather to load Arabic or English database columns
  static String columnLocale(BuildContext context) {
    if (currentLanguage(context) == Localization.languages.first) return 'en';
    return 'ar';
    // return ar
    // return en
  }
}
