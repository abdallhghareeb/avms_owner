import 'dart:ui' as ui;
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:dialog_loader/dialog_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCustomAdaptiveDialog({
  required BuildContext context,
  required String title,
  required String content,
  bool showCancelButton = true,
  String okButtonText = 'Ok',
  VoidCallback? onOkPressed, // Optional callback for the Ok button
}) {
  final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  final ui.TextDirection textDirection = Directionality.of(context);

  Widget buildDialog(Widget child) {
    return Directionality(
      textDirection: textDirection,
      child: child,
    );
  }

  List<Widget> buildActions() {
    List<Widget> actions = [];

    if (showCancelButton) {
      actions.add(isIOS
          ? CupertinoDialogAction(
              child: const Text('cancel').tr(),
              onPressed: () => Navigator.pop(context),
            )
          : TextButton(
              child: const Text('cancel').tr(),
              onPressed: () => Navigator.pop(context),
            ));
    }

    actions.add(isIOS
        ? CupertinoDialogAction(
            child: Text(okButtonText),
            onPressed: () {
              Navigator.of(context).pop();
              if (onOkPressed != null) {
                onOkPressed();
              }
            },
          )
        : TextButton(
            child: Text(okButtonText).tr(),
            onPressed: () {
              Navigator.of(context).pop();
              if (onOkPressed != null) {
                onOkPressed();
              }
            },
          ));

    return actions;
  }

  if (isIOS) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => buildDialog(
        CupertinoAlertDialog(
          title: Text(title).tr(),
          content: Text(content),
          actions: buildActions(),
        ),
      ),
    );
  } else {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => buildDialog(
        AlertDialog(
          title: Text(title).tr(),
          content: Text(content).tr(),
          actions: buildActions(),
        ),
      ),
    );
  }
}

Future<bool?> showLogoutDialog(BuildContext context) => showAlertDialog(context,
    title: 'هل تريد تسجيل الخروج ؟', imageUrl: 'assets/images/logout.png');

Future<bool?> showAlertDialog(BuildContext context,
    {required String title, required String imageUrl}) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(KBorderRadius)),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(imageUrl, height: 50),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title, style: const TextStyle(fontSize: 16))),
                Row(
                  textDirection: ui.TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('نعم',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                color: Color(0xFFA01D20), width: 1),
                          ),
                        ),
                        child: const Text('لا',
                                style: TextStyle(color: Color(0xFFA01D20)))
                            .tr(),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });
}

void showInformationDialog({
  required BuildContext context,
  required String title,
  required String content,
  VoidCallback? onOkPressed, // Optional callback for the Ok button
}) {
  final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

  if (isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        insetAnimationCurve: Curves.bounceIn,
        title: Row(
          children: [
            Icon(Icons.cancel, color: Colors.grey),
            AppSpaces.hSpace10,
            Text(title).tr(),
          ],
        ),
        content: Text(content).tr(),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
              if (onOkPressed != null) {
                onOkPressed();
              }
            },
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.cancel, color: Colors.grey),
            AppSpaces.hSpace10,
            Text(title).tr(),
          ],
        ),
        content: Text(content).tr(),
        elevation: 10,
        actions: <Widget>[
          TextButton(
            child: const Text('cancel').tr(),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('ok').tr(),
            onPressed: () {
              Navigator.of(context).pop();
              if (onOkPressed != null) {
                onOkPressed();
              }
            },
          ),
        ],
      ),
    );
  }
}

// showLoaderDialog(BuildContext context) {
//   AlertDialog alert = AlertDialog(
//     content: Row(
//       children: [
//         CircularProgressIndicator(),
//         AppSpaces.hSpace16,
//         Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
//       ],
//     ),
//   );
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }

// DialogLoader? dialogLoader;

// showDialogLoader(context) async {
//   dialogLoader = DialogLoader(context: context);
//
//   dialogLoader?.show(
//     theme: LoaderTheme.dialogCircle,
//     title: Text("Loading"),
//     leftIcon: SizedBox(
//       child: CircularProgressIndicator(),
//       height: 25.0,
//       width: 25.0,
//     ),
//   );
// }

// closeDialogLoader(context) async => dialogLoader?.close();
