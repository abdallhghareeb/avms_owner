import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/app_size.dart';
import 'package:avms/core/utils/app_spaces.dart';
import 'package:avms/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';

void showSuccessDialog(context, String? text,
    [VoidCallback? afterDuration]) async {
  final res = showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Center(
                    child: Image.asset(
                  "assets/icons/success.gif",
                  height: 82,
                  width: 117,
                ))),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Center(
                  child: Text(
                text ?? "تم بنجاح",
                style: const TextStyle(fontSize: 18),
              )),
            ),
          ],
        );
      });

  res.whenComplete(() => afterDuration != null ? afterDuration() : null);
  res.timeout(const Duration(milliseconds: 2000),
      onTimeout: () => Navigator.pop(context));
}

void showQrDialog(
    {required BuildContext context,
    required String qrImage,
    required String buttonName,
    required VoidCallback onPressed,
    bool isCreateInvitation = false,
    }) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return TransparentDialog(qrImg: qrImage, onPressed: onPressed,buttonName:buttonName ,isCreateInvitation:isCreateInvitation ,);
    },
  );
}

class TransparentDialog extends StatelessWidget {
  final String qrImg, buttonName;
  final VoidCallback onPressed;
  final bool isCreateInvitation;

  const TransparentDialog({
    super.key,
    required this.qrImg,
    required this.buttonName,
    required this.onPressed,
    required this.isCreateInvitation,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              qrImg, // Replace with your image URL
              width: SizeConfig.screenWidth * 0.8,
              height: SizeConfig.screenHeight * 0.4,
              // fit: BoxFit.cover,
            ),
            AppSpaces.hSpace16,
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsetsDirectional.all(
                    16.0,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  Colors.white,
                ),
              ),
              onPressed: onPressed,
              child: Text(
                buttonName,
                style: TextStyle(
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            AppSpaces.hSpace16,
            Visibility(
              visible: isCreateInvitation,
              child: Lottie.asset(
                'assets/images/animations/success.json',
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// void shareImage(String imageUrl) async {
//   // var request = await HttpClient().getUrl(Uri.parse(imageUrl));
//   // var response = await request.close();
//   // Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//   // Share.shareXFiles(
//   //   [
//   //     XFile.fromData(bytes),
//   //   ],
//   //   text: 'Qr Invitation.png',
//   // );
//
//   final url = Uri.parse(imageUrl);
//   final res = await http.get(url);
//   final bytes = res.bodyBytes;
//
//   final temp = await getTemporaryDirectory();
//   final path = '${temp.path}/Qr_invitation.png';
//   // await XFile('/yourPath/myItem.png').writeAsBytes(response.bodyBytes);
//   await Share.shareXFiles([XFile(path)], text: 'Image Shared');
// }
