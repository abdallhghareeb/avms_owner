import 'dart:math';
import 'package:avms/core/utils/hex_color.dart';
import 'package:flutter/material.dart';

class AppColors {
  static MaterialColor primaryColor = generateMaterialColor(appColor);
  static Color secondaryColor = generateMaterialColor(offWhite);

  static final HexColor appColor = HexColor('#0770a6');
  static final HexColor offWhite = HexColor('#f5f5f6'); // light background
  static final HexColor grey = HexColor('#6D6D6D'); // caption
  static final HexColor lightGrey =
      HexColor('#2C2C2C'); // button grey , text-field background
  static final HexColor secondGrey = HexColor('#7D7D7D'); // textfield hint
  static final HexColor darkBlue = HexColor('#0047A5'); // textfield hint
  static final HexColor activeStatus = HexColor("#61a5c2"); // textfield hint
  static final HexColor successStatus = HexColor("#80ed99"); // textfield hint
  static final HexColor expiredStatus = HexColor("#84a98c"); // textfield hint
  static final HexColor canceledStatus = HexColor("#f9844a"); // textfield hint
  static final HexColor blockedStatus = HexColor("#d87072"); // textfield hint

  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  static int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  static Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  static int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  static Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);
}
