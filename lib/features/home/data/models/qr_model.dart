import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/features/home/domain/entities/Qr.dart';

class QrModel extends Qr {
  QrModel({
    required String Message,
    required String qrImage,
  }) : super(Message: Message, qrImage: qrImage);

  factory QrModel.fromJson(Map<String, dynamic> json) {
    // Log the qrLink from the JSON for debugging purposes
    logger.e(json['qrLink']);

    // Ensure you have 'message' available from the JSON or provide a default
    return QrModel(
      Message: json['Message'] ?? 'default message', // Provide a default if message is missing
      qrImage: json['qrLink'],
    );
  }

  Map<String, dynamic> toJson() => {
    'Message': Message, // Include message in JSON representation
    'qrLink': qrImage,
  };
}
