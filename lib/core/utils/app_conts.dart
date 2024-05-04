import 'package:avms/core/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

GlobalKey<ScaffoldMessengerState> ScaffoldGlobalKey =
    GlobalKey<ScaffoldMessengerState>();

final logger = Logger();


String? userToken;

bool rememberMe = false;

const KBorderRadius = 8.0;
const double smallBorderRadius = 8.0;
const borderRadius = 20.0;
const midBorderRadius = 10.0;
const minBorderRadius = 10.0;
const mainPadding = 20.0;
const midPadding = 16.0;
const smallPadding = 8.0;
const elevation = 5.0;

// used for container background color of the scaffold

final KTextFieldDecoration = InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    fillColor: Colors.grey.shade100.withOpacity(0.5),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(KBorderRadius),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(KBorderRadius),
      borderSide: const BorderSide(color: Colors.blueAccent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(KBorderRadius),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(KBorderRadius),
      borderSide: const BorderSide(color: Colors.red),
    ),
    isCollapsed: true,
    contentPadding: const EdgeInsets.all(8),
    labelStyle: const TextStyle(color: Colors.black));

final TextFieldDecoration = InputDecoration(

  filled: true,
  fillColor: AppColors.offWhite,
  border: OutlineInputBorder(
    borderSide: BorderSide(
      width: 5.0,
      color: AppColors.secondaryColor,
    ),
    borderRadius: BorderRadius.circular(10.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.offWhite,
      width: 5.0,
    ),
    borderRadius: BorderRadius.circular(15.0),

  ),
);

final KDiscountDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border:
      OutlineInputBorder(borderRadius: BorderRadius.circular(KBorderRadius)),
  // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(KBorderRadius), borderSide: const BorderSide(color: KAccentBlue)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(KBorderRadius),
      borderSide: BorderSide(color: AppColors.offWhite)),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(KBorderRadius),
      borderSide: const BorderSide(color: Colors.red)),
  errorMaxLines: 1,
  hintText: "0",
  hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
  isCollapsed: true,
  isDense: false,
  errorStyle: const TextStyle(fontSize: 12.5, height: 1.1),
  contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
);

const KQuantityDecoration = InputDecoration(
  border: InputBorder.none,
  focusedBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  errorMaxLines: 0,
  hintText: "0",
  hintStyle: TextStyle(color: Colors.grey),
  isCollapsed: true,
  isDense: true,
  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
);

String currency(double value) {
  if (value == 0) return '0';

  final oCcy = NumberFormat("#,##0.##", "en_US");

  // final formattedValue = value.toStringAsFixed(2);
  // final parsedValue = double.parse(formattedValue);

  // return oCcy.format(parsedValue);
  return oCcy.format(value);
}

final KRemoveEmoji = FilteringTextInputFormatter.deny(RegExp(
    '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'));

const shadow = [
  BoxShadow(
    color: Colors.black12,
    blurRadius: 10.0,
    spreadRadius: .5,
    offset: Offset(0.0, 2.0),
  ),
];
final removeEmoji = FilteringTextInputFormatter.deny(
  RegExp(
      '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
);

String handleLargeNumbers(String text, {bool? isMeter}) {
  double num = double.parse(text);
  String result = num.toString();
  if (num >= 1000) {
    if (isMeter == true) {
      result = "${(num / 1000).round()}K";
    } else {
      result = "${(num / 1000)}K";
    }
  } else
    result = num.round().toString();
  return result;
}

class Nothing extends StatelessWidget {
  const Nothing({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
