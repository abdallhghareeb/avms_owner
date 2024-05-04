import 'dart:convert';
import 'dart:io';
import 'package:avms/services/api_service/end_point.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    debugPrint("DioHelper init");
    dio = Dio(
      BaseOptions(
          baseUrl: BASE_URL,
          validateStatus: (int? status) {
            return status != null;
            // return status != null && status >= 200 && status < 300;
          },
          receiveDataWhenStatusError: true,
          headers: {
            'Content-Type': 'application/json',
          }),
    );
  }

  static Future<Response> postSignIn({
    required String url,
    required Map<String, dynamic>? parameters,
  }) async {
    final jsonBody = json.encode(parameters);
    debugPrint('~parameters ${jsonBody}');
    _debugPrintData(
      title: '==postSignIn==',
      data: jsonBody,
      endPoint: url,
    );

    return await dio.post(
      url,
      data: jsonBody,
    );
  }

  static Future<Response> postForgetPassword({
    required String url,
    required Map<String, dynamic>? parameters,
  }) async {
    final jsonBody = json.encode(parameters);
    debugPrint('~parameters ${jsonBody}');
    _debugPrintData(
      title: '==PostForgetPassword==',
      data: jsonBody,
      endPoint: url,
    );

    return await dio.post(
      url,
      data: jsonBody,
    );
  }

  static Future<Response> postResetPassword({
    required String url,
    required Map<String, dynamic>? parameters,
  }) async {
    final jsonBody = json.encode(parameters);
    debugPrint('~parameters ${jsonBody}');
    _debugPrintData(
      title: '==PostResetPassword==',
      data: jsonBody,
      endPoint: url,
    );

    return await dio.post(
      url,
      data: jsonBody,
    );
  }

  static Future<Response> getDashboardInfo({
    required String url,
  }) async {
    _debugPrintData(
      title: '==GetDashboardInfo==',
      endPoint: url,
    );

    return await dio.get(
      url,
    );
  }

  static Future<Response> getInvitationVisits({required String url}) async {
    _debugPrintData(
      title: '==GetAllInvitationsVisits==',
      endPoint: url,
    );

    return await dio.get(
      url,
    );
  }

  static Future<Response> createInvitation(
      {required String url, required Map<String, dynamic> param}) async {
    _debugPrintData(title: '==CreateInvitation==', endPoint: url, data: param);

    return await dio.post(
      url,
      data: param,
    );
  }

  static Future<Response> cancelInvitationVisit({
    required String url,
    required dynamic data,
  }) async {
    _debugPrintData(
        title: '==CancelInvitationVisit==', endPoint: url, data: data);

    return await dio.post(url, data: data);
  }
  static Future<Response> getByID({
    required String url,
  }) async {
    _debugPrintData(
        title: '==GetByID==', endPoint: url);

    return await dio.get(url);
  }
}

_debugPrintData({String? title, String? endPoint, data}) {
  debugPrint('Title => $title');
  debugPrint('URL => ${endPoint!}');
  debugPrint('Method => ${DioHelper.dio.options.method.toString()}');
  debugPrint('Header => ${DioHelper.dio.options.headers.toString()}');
  debugPrint(
      'responseType => ${DioHelper.dio.options.responseType.toString()}');
  data != null ? printFullText('Body => $data') : null;
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
