import 'dart:convert';
import 'package:avms/features/auth/data/models/create_inv_model.dart';
import 'package:avms/features/auth/data/models/unit_model.dart';
import 'package:avms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:avms/features/auth/presentation/screens/login_screen.dart';
import 'package:avms/features/home/data/models/api_res_create_inv.dart';
import 'package:avms/features/home/data/models/api_response.dart';
import 'package:avms/features/home/data/models/dashInfo_Model.dart';
import 'package:avms/features/home/data/models/document_type.dart';
import 'package:avms/features/home/data/models/get_all_inv.dart';
import 'package:avms/features/home/data/models/invtation_model.dart';
import 'package:avms/services/api_service/end_point.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';

import '../../features/auth/data/models/area_unit.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    debugPrint("DioHelper init");
    dio = Dio(
      BaseOptions(
          baseUrl: SaveApiUrl ?? '',
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

  static void updateToken() {
    dio.options.headers['Authorization'] = 'Bearer $TokenSave';
  }

  static Future<List<Area>> fetchAreas() async {
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
    try {
      Response response =
          await dio.get('$BASE_URL$SaveApiUrl$getAreaUnitEndPoint');
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
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));

    try {
      final response = await dio.get(
        '$BASE_URL$SaveApiUrl/api/v1/units', // Replace with your units endpoint
      );

      if (response.statusCode == 200) {
        List<dynamic> unitsJson = response.data['data'];
        List<Unit> units =
            unitsJson.map((json) => Unit.fromJson(json)).toList();
        return units;
      } else {
        throw Exception('Failed to load units');
      }
    } catch (e) {
      throw Exception('Failed to load units: $e');
    }
  }

  static Future<List<VisitModel>> fetchData({
    required BuildContext context,
    required String token,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      Response response = await dio.get(
        '$BASE_URL$SaveApiUrl$getAllInvitationsEndPoint',
        queryParameters: parameters,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data['data']['data'];
        return responseData.map((json) => VisitModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: 'Session expired. Please log out and log in again.',backgroundColor: Colors.red);
        AuthCubit.get(context).signOut(context: context);

        return []; // Return an empty list to prevent further processing.
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<VisitModel>> fetchDataToInvtations({
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
        return responseData
            .map((json) => VisitModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<Area>> fetchAreasWi(String ownerId) async {
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
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

  static Future<List<Area>> fetchAreasWithHaveOwners() async {
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
    try {
      final response = await dio.get('$GetAll');
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        // Parse the data into Area objects
        final areas = data.map((json) => Area.fromJson(json)).toList();
        // Filter the areas to include only those with owners
        final areasWithOwners =
            areas.where((area) => area.owners.isNotEmpty).toList();
        return areasWithOwners;
      } else {
        throw Exception('Failed to load areas');
      }
    } catch (e) {
      print('Error fetching areas: $e');
      throw Exception('Failed to load areas');
    }
  }

  static Future<List<Area>> fetchAreasWithoutOwners() async {
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
    try {
      final response = await dio.get('$GetAll');
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        // Parse the data into Area objects
        final areas = data.map((json) => Area.fromJson(json)).toList();
        // Filter the areas to include only those without owners,
        // that are not deleted, and are active
        final areasWithoutOwners = areas
            .where((area) =>
                area.owners.isEmpty &&
                !area.isDeleted &&
                area.isUnit &&
                area.isActive)
            .toList();
        return areasWithoutOwners;
      } else {
        throw Exception('Failed to load areas');
      }
    } catch (e) {
      print('Error fetching areas: $e');
      throw Exception('Failed to load areas');
    }
  }

  static Future<Map<String, dynamic>> fetchUserData(String userId) async {
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
    try {
      Response response = await dio.get(
        '/api/v1/user/$userId',
        options: Options(headers: {
          'accept': '*',
          'Authorization': 'bearer $TokenSave',
        }),
      );
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        print(
            'Error fetching user data: ${e.response?.statusCode} - ${e.response?.statusMessage}');
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
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));

    return await dio.post(
      url,
      data: jsonBody,
    );
  }

  static Future<Response> postSignUp({
    required String url,
    required FormData parameters,
  }) async {
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
    return await Dio().post(url, data: parameters);
  }

  static Future<Response> postData({
    Map<String, dynamic>? queryParameters,
    required String url,
    required String token,
    required Map<String, dynamic> data,
  }) async {
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    return await dio.post(url, data: data, queryParameters: queryParameters);
  }

  static Future<Response> postDataToBlackList({
    required String url,
    required String token,
    required FormData data,
  }) async {
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
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
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
    return await dio.get(
      url,
    );
  }

  static Future<Response> postDataForRequest({
    required String url,
    required String token,
    required FormData data,
  }) async {
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
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
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
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
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
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

  static Future<ApiResponseToCreateInv> createToInvitations({
    required String url,
    required FormData param,
    required String token,
  }) async {
    final dio = Dio();
    final options = Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      },
    );

    final response = await dio.post(url, data: param, options: options);
    return ApiResponseToCreateInv.fromJson(response.data);
  }
  static Future<List<VisitModel>> fetchDataToDash({
    required String token,
    Map<String, dynamic>? parameters,
    required BuildContext context,
  }) async {
    try {
      Response response = await dio.get(
        '$BASE_URL$SaveApiUrl$getAllInvitationsEndPoint',
        queryParameters: parameters,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data['data']['data'];
        List<VisitModel> visits = responseData
            .map((json) => VisitModel.fromJson(json))
            .toList();

        // Filter out expired and canceled invitations
        visits = visits.where((visit) => !isExpiredOrCanceled(visit)).toList();

        return visits;
      } else if (response.statusCode == 401) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
        );

        // Show session expired message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session expired. Please log in again.')),
        );
        return []; // Return an empty list after navigating to login
      } else {
        // Handle other status codes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode} - ${response.statusMessage}')),
        );
        return [];
      }
    } catch (e) {
      // Handle exceptions and show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return [];
    }
  }

  static bool isExpiredOrCanceled(VisitModel visit) {
    // Implement the logic to determine if the invitation is expired or canceled
    // For example:
    return visit.status == 'Expired'||visit.status=='Canceld' ;
  }

  static Future<DashboardTabsInfo?> fetchDashInfo(BuildContext context) async {
    try {
      final response = await Dio().get(
        '$BASE_URL$SaveApiUrl$getDashInfoEndPoint',
        options: Options(
          headers: {
            'Authorization': 'Bearer $TokenSave',
          },
        ),
      );
      if (response.statusCode == 200) {
        return DashboardTabsInfo.fromJson(response.data);
      } else if (response.statusCode == 401) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          // Replace with your LoginScreen widget
          (route) => false,
        );

        // Show session expired message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session expired. Please log in again.')),
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching dashboard info: $e');
      return null;
    }
  }

  static Future<List<DocumentType>> getInvitationDocTypes({
    required BuildContext context,
  }) async {
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        // Adjust this based on your requirements. True for all non-null status.
        return status != null;
      },
      receiveDataWhenStatusError: true,
    ));

    try {
      Response response = await dio.get(
        '/api/v1/InvitationDocType/get',
        options: Options(
          headers: {
            'Authorization': 'Bearer $TokenSave',
          },
        ),
      );
       if (response.statusCode == 401) {
        Fluttertoast.showToast(

            msg: 'Session expired. Please log out and log in again.',backgroundColor: Colors.red);
        AuthCubit.get(context).signOut(context: context);

        return []; // Return an empty list to prevent further processing.
      }

      if (response.statusCode != 200) {
        // Handle non-success status codes (e.g., 404, 500)
        throw Exception('Failed to load data: ${response.statusCode}');
      }

      final apiResponse = ApiResponse.fromJson(response.data);

      // Filter out documents where "isDeleted" is true
      List<DocumentType> filteredDocTypes = apiResponse.data
          .where((docType) => docType.isDeleted == false)
          .toList();

      return filteredDocTypes;
    } catch (e) {
      // Handle errors (e.g., network issues, JSON parsing errors)
      print('Error fetching document types: $e');
      return []; // Return an empty list or handle the error as needed
    }
  }

  static Future<Response> getDashboardInfo({
    required String url,
  }) async {
    _debugPrintData(
      title: '==GetDashboardInfo==',
      endPoint: url,
    );
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
    return await dio.get(
      url,
    );
  }

  static Future<Response> getInvitationVisits({required String url}) async {
    _debugPrintData(
      title: '==GetAllInvitationsVisits==',
      endPoint: url,
    );
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
    return await dio.get(
      url,
    );
  }

  static Future<Response> createInvitation(
      {required String url,
      required FormData param,
      required String token}) async {
    _debugPrintData(title: '==CreateInvitation==', endPoint: url, data: param);
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
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
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
    return await dio.post(url, data: data);
  }

  static Future<Response> getByID({
    required String url,
  }) async {
    _debugPrintData(title: '==GetByID==', endPoint: url);
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
    return await dio.get(url);
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    final Dio dio = Dio(BaseOptions(
      baseUrl: '$BASE_URL$SaveApiUrl',
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $TokenSave',
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
      receiveDataWhenStatusError: true,
    ));
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
