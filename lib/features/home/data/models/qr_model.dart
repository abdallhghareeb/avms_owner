
import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/features/home/domain/entities/Qr.dart';

class QrModel extends Qr {
  QrModel({
    required String qrImage,
  }) : super(qrImage: qrImage);

  factory QrModel.fromJson(Map<String, dynamic> json) {
    logger.e(json['qrLink']);
    return QrModel(
      qrImage: json['qrLink'],
    );
  }

  Map<String, dynamic> toJson() => {
        'qrLink': qrImage,
      };
}
