import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class AppSpaces {
  static SizedBox hSpace5 = const SizedBox(
    width: 5.0,
  );
  static SizedBox vSpace5 = const SizedBox(
    height: 5.0,
  );
  static SizedBox hSpace10 = const SizedBox(
    width: 10.0,
  );
  static SizedBox hSpace16 = const SizedBox(
    width: 16.0,
  );
  static SizedBox vSpace10 = const SizedBox(
    height: 10.0,
  );
  static SizedBox hSpace20 = const SizedBox(
    width: 20.0,
  );
  static SizedBox vSpace20 = const SizedBox(
    height: 20.0,
  );
  static SizedBox vSpace30 = const SizedBox(
    height: 30.0,
  );
  static SizedBox vSpace16 = const SizedBox(
    height: 16.0,
  );
  static Expanded expandedSpace = const Expanded(child: SizedBox());
  final logger = Logger();
  static final removeEmoji = FilteringTextInputFormatter.deny(
    RegExp(
        '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
  );
}
