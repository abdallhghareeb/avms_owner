import 'package:avms/features/home/domain/entities/visit.dart';

class VisitModel extends Visit {
  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'] as String?,
      fullName: json['fullName'] as String?,
      documentId: json['documentId'] as String?,
      areaName: json['areaName'] as String?,
      accessOutDate: json['accessOutDate'] as String?,
      documentImage: json['documentImage'],
      accessInDate: json['accessInDate'] as String?,
      isSuccess: json['isSuccess'],
      cardNumber: json['cardNumber'] as String?,
      registrationDate: json['registrationDate'] as String?,
      expiryDate: json['expiryDate'],
      qrLink: json['qrLink'],
      status: json['statusValue'],
    );
  }

  VisitModel({
    required String? id,
    required String? fullName,
    required String? documentId,
    required String? registrationDate,
    required String? accessInDate,
    required String? accessOutDate,
    required String? areaName,
    final String? expiryDate,
    required String qrLink,
    required String? documentImage,
    required String? cardNumber,
    required bool? isSuccess,
    required String? status,
  }) : super(
          id: id,
          fullName: fullName,
          documentId: documentId,
          registrationDate: registrationDate,
          expiryDate: expiryDate,
          accessInDate: accessInDate,
          accessOutDate: accessOutDate,
          areaName: areaName,
          cardNumber: cardNumber,
          qrLink: qrLink,
          documentImage: documentImage,
          isSuccess: isSuccess,
          status: status,
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'areaName': areaName,
        'registrationDate': registrationDate,
        'documentId': documentId,
        'cardNumber': cardNumber,
        'isSuccess': isSuccess,
        'qrLink': qrLink,
        'documentImage': documentImage
      };
}
