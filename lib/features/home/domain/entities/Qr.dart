import 'package:equatable/equatable.dart';

class Qr extends Equatable {
  final String qrImage;

    Qr({
    required this.qrImage,
    });


  @override
  String toString() {
    return 'Qr{qrImage: $qrImage}';
  }

  @override
  List<Object?> get props => [
    qrImage,
  ];
}
