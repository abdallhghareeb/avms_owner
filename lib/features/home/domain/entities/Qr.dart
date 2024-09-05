import 'package:equatable/equatable.dart';

class Qr extends Equatable {
  final String Message;
  final String qrImage;

  Qr({
    required this.Message,
    required this.qrImage,
  });

  @override
  String toString() {
    return 'Qr{message: $Message, qrImage: $qrImage}';
  }

  @override
  List<Object?> get props => [
    Message,
    qrImage,
  ];
}
