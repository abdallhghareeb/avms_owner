import 'package:avms/features/home/domain/entities/visit.dart';

class VisitModel extends Visit {
  VisitModel({
    required String id,
    required String fullName,
    required String registrationDate,
    required String documentId,
    required String cardNumber,
    required String areaName,
    required String expiryDate,
    required String qrLink,
    required dynamic accessInDate,
    required dynamic accessOutDate,
    required String documentImage,
    required bool isSuccess,
    required String status,
    required int  areaId
  }) : super(
    id: id,
    fullName: fullName,
    registrationDate: registrationDate,
    documentId: documentId,
    cardNumber: cardNumber,
    areaName: areaName,
    expiryDate: expiryDate,
    qrLink: qrLink,
    accessInDate: accessInDate,
    accessOutDate: accessOutDate,
    documentImage: documentImage,
    isSuccess: isSuccess,
    status: status,
    areaId: areaId
  );

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      registrationDate: json['registrationDate'] ?? '',
      documentId: json['documentId'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      areaName: json['areaNames'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      qrLink: json['qrLink'] ?? '',
      accessInDate: json['accessInDate'] ?? '',
      accessOutDate: json['accessOutDate'] ?? '',
      documentImage: json['documentImage'] ?? '',
      isSuccess: json['isSuccess'] ?? false,
      status: json['statusValue'] ?? '',
      areaId: json['areaId']
    );
  }
}
