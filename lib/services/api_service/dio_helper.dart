import 'dart:convert';
import 'dart:io';
import 'package:avms/features/auth/data/models/reg_response.dart';
import 'package:avms/features/auth/data/models/register_model.dart';
import 'package:avms/features/auth/data/models/unit_model.dart';
import 'package:avms/features/home/data/models/get_all_inv.dart';
import 'package:avms/features/home/domain/entities/visit.dart';
import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/services/api_service/inter_ceptor.dart';
import 'package:avms/services/local/cache_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../features/auth/data/models/area_unit.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    debugPrint("DioHelper init");
    dio = Dio(
      BaseOptions(
          baseUrl: '$BASE_URL$SaveApiUrl',

          validateStatus: (int? status) {
            return status != null;
            // return status != null && status >= 200 && status < 300;
          },
          receiveDataWhenStatusError: true,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $TokenSave',
          }),
    );
  }
 static Future<List<Area>> fetchAreas() async {
    try {
      Response response = await dio.get('http://egydns.ddns.net:8622/api/v1/area/unit');
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        List<Area> areas = data.map((json) => Area.fromJson(json)).toList();
        return areas;
      } else {
        throw Exception("Failed to load areas");
      }
    } catch (e) {
      throw Exception("Failed to load areas: $e");
    }
  }



  static Future<List<Unit>> fetchUnits() async {
    try {
      final response = await dio.get(
        'http://egydns.ddns.net:8622/api/v1/units', // Replace with your units endpoint
      );

      if (response.statusCode == 200) {
        List<dynamic> unitsJson = response.data['data'];
        List<Unit> units = unitsJson.map((json) => Unit.fromJson(json)).toList();
        return units;
      } else {
        throw Exception('Failed to load units');
      }
    } catch (e) {
      throw Exception('Failed to load units: $e');
    }
  }

  static Future<List<VisitModel>> fetchData({
    required String token,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      Response response = await dio.get(
        '$BASE_URL$SaveApiUrl$getAllInvitationsEndPoint',
        queryParameters: parameters,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data['data']['data'];
        return responseData.map((json) => VisitModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  static Future<List<Area>> fetchAreasWi(String ownerId) async {
    try {
      // Pass the ownerId as a query parameter
      Response response = await dio.get(
        '$BASE_URL$SaveApiUrl$GetAll',
        queryParameters: {'ownerId': ownerId},
      );
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        List<Area> areas = data.map((json) => Area.fromJson(json)).toList();
        return areas;
      } else {
        throw Exception("Failed to load areas");
      }
    } catch (e) {
      throw Exception("Failed to load areas: $e");
    }
  }

 static Future<List<Area>> fetchAreasWithoutAllOwners(String unitId) async {
    try {
      final response = await dio.get(
        '$BASE_URL$SaveApiUrl$GetUnitWithId$unitId',
      );

      if (response.statusCode == 200) {
        List<dynamic> areasJson = response.data['data'];
        List<Area> areas = areasJson
            .map((json) => Area.fromJson(json))
            .where((area) => area.owners.isEmpty)
            .toList();
        return areas;
      } else {
        throw Exception('Failed to load areas');
      }
    } catch (e) {
      throw Exception('Failed to load areas: $e');
    }
  }

  static Future<List<Area>> fetchAreasWithOwners() async {
    try {
      final response = await dio.get(
        '$BASE_URL$SaveApiUrl$GetAll',
      );

      if (response.statusCode == 200) {
        List<dynamic> areasJson = response.data['data'];
        List<Area> areas = areasJson
            .map((json) => Area.fromJson(json))
            .where((area) => area.isActive) // Filter areas where isActive is true
            .where((area) => area.owners.isNotEmpty) // Filter areas with owners
            .where((area) => area.isUnit == true) // Filter areas where isUnit is true
            .toList();
        return areas;
      } else {
        throw Exception('Failed to load areas');
      }
    } catch (e) {
      throw Exception('Failed to load areas: $e');
    }
  }
  static Future<List<Area>> fetchAreasWithoutOwners() async {
    try {
      final response = await dio.get('$BASE_URL$SaveApiUrl$GetAll');

      if (response.statusCode == 200) {
        List<dynamic> areasJson = response.data['data'];
        List<Area> areas = areasJson
            .map((json) => Area.fromJson(json))
            .where((area) => area.owners.isEmpty && area.isUnit) // Filter areas without owners and isUnit is true
            .toList();
        return areas;
      } else {
        throw Exception('Failed to load areas');
      }
    } catch (e) {
      throw Exception('Failed to load areas: $e');
    }
  }
  static Future<Map<String, dynamic>> fetchUserData(String userId) async {
    try {
      Response response = await dio.get(
        '$BASE_URL$SaveApiUrl/api/v1/user/$userId',
        options: Options(headers: {
          'accept': '*',
          'Authorization': 'bearer $TokenSave',
        }),
      );
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        print('Error fetching user data: ${e.response?.statusCode} - ${e.response?.statusMessage}');
        if (e.response?.statusCode == 404) {
          return {
            'error': 'User not found',
          };
        }
      } else {
        print('Error fetching user data: $e');
      }
      return {};
    }
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
  static Future<Response> postSignUp({
    required String url,
    required FormData parameters,
  }) async {
    return await Dio().post(url, data: parameters);
  }
  static Future<Response> postData({
    required String url,
    required String token,
    required Map<String, dynamic> data,
  }) async {
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    return await dio.post(url, data: data);
  }
  static Future<Response> getAreaUnit({required String url}) async {
    _debugPrintData(
      title: '==GetAllInvitationsVisits==',
      endPoint: url,
    );

    return await dio.get(
      url,
    );
  }

  static Future<Response> postDataForRequest({
    required String url,
    required String token,
    required FormData data,
  }) async {
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    return await dio.post(url, data: data);
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
      {required String url, required FormData param,required String token}) async {


    _debugPrintData(title: '==CreateInvitation==', endPoint: url, data: param);

    return await dio.post(
      url,
      data: param,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
          'Authorization': 'Bearer $token',
        },
      ),
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
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': 'bearer $token',
    };
    return await dio.get(url, queryParameters: query);
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

