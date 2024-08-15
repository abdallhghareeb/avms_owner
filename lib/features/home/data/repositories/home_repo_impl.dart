import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
class HomeRepoImpl extends HomeRepo {
  @override
  // Future<Info> getDashInfo() async {
  //   final res = await handleRequest(
  //       () => DioHelper.getDashboardInfo(url: BASE_URL +SaveApiUrl!+ getDashInfoEndPoint));
  //   logger.d("getDashInfo respoo ${res.data}");
  //   return InfoModel.fromJson(res.data);
  // }

  @override
  Future<List<Visit>> getInvitationsVisit() async {
    final res = await handleRequest(
      () => DioHelper.getInvitationVisits(
          url: SaveApiUrl! + getAllInvitationsEndPoint),
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
    required String AreaId,
    required DateTime registerDate,
    required DateTime expiredDate,
    required XFile file,
    required String token,
    required int DocTypeId,
    documentImage,
    cardNumber,
  }) async {
    final logger = Logger();

    final formData = FormData.fromMap({
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "Image": await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      "documentId": nationalId,
      "registrationDate": DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'", "en_US").format(registerDate.toUtc()),
      "expiryDate": DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'", "en_US").format(expiredDate.toUtc()),
      "AreaId": AreaId,
      'DeviceIp': '147',
      'InvitDocType':DocTypeId
    });

    final res = await handleRequest(
          () async => DioHelper.createInvitation(
        url:BASE_URL+ SaveApiUrl! + postCreateInvitationsEndPoint,
        param: formData, token: token,
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
        url: SaveApiUrl! + getInvitationByIDEndPoint + ID,
      ),
    );

    logger.w("getByID resoo ${res.data}");
    return VisitModel.fromJson(res.data);
  }

  @override
  Future<Info> getDashInfo() {
    // TODO: implement getDashInfo
    throw UnimplementedError();
  }
}
