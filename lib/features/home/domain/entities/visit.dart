import 'package:equatable/equatable.dart';

class Visit extends Equatable {
  final String? id;
  final String? fullName;
  final String? registrationDate;
  final String? documentId;
  final String? documentImage;
  final String? cardNumber;
  final String? expiryDate;
  final String? areaName;
  final bool? isSuccess;
  final dynamic accessInDate;
  final dynamic accessOutDate;
  final String? status;
  final String? qrLink;

  Visit({
    required this.id,
    required this.fullName,
    required this.registrationDate,
    required this.documentId,
    required this.cardNumber,
    required this.areaName,
    required this.expiryDate,
    required this.qrLink,
    required this.accessInDate,
    required this.accessOutDate,
    required this.documentImage,
    required this.isSuccess,
    required this.status
  });

  bool isToday() {
    DateTime now = DateTime.now();
    DateTime registerDate = DateTime.parse(registrationDate.toString());

    return now.year == registerDate.year &&
        now.month == registerDate.month &&
        now.day == registerDate.day;
  }

  bool isUpcoming() {
    DateTime now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    DateTime registerDate = DateTime.parse(registrationDate.toString());

    return registerDate.isAfter(now);
  }

  bool isExpired() {

    DateTime now = DateTime.now();
    DateTime expiredDate = DateTime.parse(expiryDate == null
        ? registrationDate.toString()
        : expiryDate.toString());

    return now.isAfter(expiredDate);
  }

  String visitState() {
    DateTime now = DateTime.now();
    DateTime registerDate = DateTime.parse(registrationDate.toString());
    DateTime expiredDate = DateTime.parse(expiryDate == null
        ? registrationDate.toString()
        : expiryDate.toString());
    if (now.year == registerDate.year &&
        now.month == registerDate.month &&
        now.day == registerDate.day) {
      return "Today Visit";
    } else if (registerDate.isAfter(now)) {
      return "UpComing Visit";
    } else if (expiredDate.isBefore(now)) {
      return "Expired Visit";
    } else
      return '';
  }

  @override
  String toString() {
    return 'Visit{id: $id, fullName: $fullName, registrationDate: $registrationDate, documentId: $documentId, documentImage: $documentImage, cardNumber: $cardNumber, expiryDate: $expiryDate, areaName: $areaName, qrLink: $qrLink, isSuccess: $isSuccess, accessInDate: $accessInDate, accessOutDate: $accessOutDate}';
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        registrationDate,
        documentId,
        documentImage,
        cardNumber,
        expiryDate,
        areaName,
        qrLink,
        isSuccess,
        accessInDate,
        accessOutDate,
      ];
}
