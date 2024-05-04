import 'dart:convert';
import 'dart:developer';

import 'package:avms/core/utils/app_conts.dart';
import 'package:avms/core/utils/exceptions.dart';
import 'package:avms/features/home/data/models/info_model.dart';
import 'package:avms/features/home/data/models/qr_model.dart';
import 'package:avms/features/home/data/models/visit_model.dart';
import 'package:avms/features/home/domain/entities/Qr.dart';
import 'package:avms/features/home/domain/entities/info.dart';
import 'package:avms/features/home/domain/entities/visit.dart';
import 'package:avms/features/home/domain/repositories/home_repo.dart';
import 'package:avms/services/api_service/dio_helper.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeRepoImpl extends HomeRepo {
  @override
  Future<Info> getDashInfo() async {
    final res = await handleRequest(
        () => DioHelper.getDashboardInfo(url: BASE_URL + getDashInfoEndPoint));
    logger.d("getDashInfo respoo ${res.data}");
    return InfoModel.fromJson(res.data);
  }

  @override
  Future<List<Visit>> getInvitationsVisit() async {
    final res = await handleRequest(
      () => DioHelper.getInvitationVisits(
          url: BASE_URL + getAllInvitationsEndPoint),
    );

    List visits = res.data;
    return visits.map((json) => VisitModel.fromJson(json)).toList();
  }

  @override
  Future<Qr> createInvitations({
    required String fullName,
    required String phone,
    required String email,
    required String nationalId,
    required DateTime registerDate,
    required DateTime expiredDate,
    documentImage,
    cardNumber,
  }) async {
    log("registerDate ${{
      "fullName": "$fullName",
      "email": "$email",
      "phone": "$phone",
      "documentImage": null,
      "documentId": "$nationalId",
      "registrationDate":
          "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'", "en_Us").format(registerDate.toUtc())}",
      // "2024-02-10T07:41:34.080Z",
      "expiryDate":
          "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'", "en_Us").format(expiredDate.toUtc())}",
      "cardNumber": null,
      "areasId": null
    }}");
    final res = await handleRequest(
      () => DioHelper.createInvitation(
        url: BASE_URL + postCreateInvitationsEndPoint,
        param: {
          "fullName": "$fullName",
          "email": "$email",
          "phone": "$phone",
          "documentImage": null,
          "documentId": "$nationalId",
          "registrationDate":
              "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'", "en_Us").format(registerDate.toUtc())}",
          // "2024-02-10T07:41:34.080Z",
          "expiryDate":
              "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'", "en_Us").format(expiredDate.toUtc())}",
          "cardNumber": "$nationalId",
          "areasId": null
        },
      ),
    );

    logger.f("createInvitationsVisit ${res.data}");

    return QrModel.fromJson(res.data);
  }

  @override
  Future<Map<String, dynamic>> cancelInvitationVisit(
      {required String canceledId}) async {
    final res = await handleRequest(() => DioHelper.cancelInvitationVisit(
            url: BASE_URL + cancelInvitationVisitEndPoint,
            data: {
              "registrationId": canceledId,
            }));

    logger.w("cancelInvitationVisit resoo statusCode ${res.statusCode}");
    return res.data;
  }

  @override
  Future<Visit> getByID({required String ID}) async {
    final res = await handleRequest(
      () => DioHelper.getByID(
        url: BASE_URL + getInvitationByIDEndPoint + ID,
      ),
    );

    logger.w("getByID resoo ${res.data}");
    return VisitModel.fromJson(res.data);
  }
}
