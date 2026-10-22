import 'dart:async';
import 'dart:developer';
import 'package:avms/features/auth/data/models/auth_response_model.dart';
import 'package:avms/services/api_service/dio_helper.dart';
import 'package:avms/widgets/snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ServerException implements Exception {
  final String message;

  const ServerException(this.message);

  @override
  String toString() {
    return message;
  }
}

class NetworkException implements Exception {
  final String message;
  final int code;

  NetworkException({required this.message, required this.code});

  @override
  String toString() {
    return 'NetworkException{message: $message, code: $code}';
  }
}

class InternetException implements Exception {
  final String message;

  InternetException({
    required this.message,
  });

  @override
  String toString() {
    return 'NetworkException{message: $message}';
  }
}

class DBException implements Exception {
  final String message;

  const DBException(this.message);

  @override
  String toString() {
    return message;
  }
}

class ValidationException implements Exception {
  final String field;
  final String message;

  ValidationException({required this.field, required this.message});

  @override
  String toString() {
    return 'ValidationException{field: $field, message: $message}';
  }
}

class LoginException implements Exception {
  final String message;
  final int code;

  LoginException({required this.message, required this.code});

  @override
  String toString() {
    return 'LoginException{message: $message, code: $code}';
  }
}

class FileException implements Exception {
  final String message;

  FileException({required this.message});

  @override
  String toString() {
    return 'FileException{message: $message}';
  }
}

class SyncException implements Exception {
  final String message;

  SyncException({required this.message});

  @override
  String toString() {
    return 'SyncException{message: $message}';
  }
}

class DataException implements Exception {
  final String message;

  DataException({required this.message});

  @override
  String toString() {
    return 'DataException{message: $message}';
  }
}

class FireBaseException implements Exception {
  final String message;

  FireBaseException({required this.message});

  @override
  String toString() {
    return 'FireBaseException{message: $message}';
  }
}

class PickCameraException implements Exception {
  final String message;

  PickCameraException({required this.message});

  @override
  String toString() {
    return 'PickCameraException{message: $message}';
  }
}

class GeneralException implements Exception {
  final String message;

  GeneralException({required this.message});

  @override
  String toString() {
    return 'GeneralException{message: $message}';
  }
}

/// this function handles any API request & show snackBar on Exception
Future handleRequest(Future<Response> Function() apiRequest,
    [VoidCallback? onException]) async {
  try {
    bool isInternetConnected = await InternetConnection().hasInternetAccess;
    if (!isInternetConnected) {
      SnackBarGlobal.show(
        message: "networkDisconnected",
      );
      // }
      throw NetworkException(
        message: "networkDisconnected",
        code: 404,
      );
    }

    final call = await apiRequest();
    final response = call.data;

    if (response is! Map<String, dynamic>) {
      throw NetworkException(
        message: 'Unexpected response (HTTP ${call.statusCode})',
        code: call.statusCode ?? 0,
      );
    }

    // print("Response_Data => ${response["data"]}");
    printFullText("Status Code => ${response["statusCode"]}");
    printFullText("Status Message => ${response["message"]}");

    switch (response["statusCode"]) {
      case 200:
        // log('Response Data => ${response}');
        return AuthResponseModel.fromJson(response);

      case 500:
        // if (context.mounted) {
        SnackBarGlobal.show(
          message: "",
        );
        // }
        throw NetworkException(
          message: response["message"] ,
          code: 500,
        );
      case 400:
        SnackBarGlobal.show(
          message: response["message"],
        );

        throw NetworkException(
          message: response["message"] + "",
          code: 500,
        );

      default:
        log('default Data => ${response.toString()}');
        throw GeneralException(
          message: response["message"],
        );
        return response;
    }
  } on NetworkException catch (e) {
    // Handle login exception
    // if (context.mounted) {
    SnackBarGlobal.show(message: e.message);
    // }
    // handleCrash(details: FlutterErrorDetails(exception: e, stack: stackTrace));

    throw NetworkException(code: e.code, message: e.message);
  } on DataException catch (e) {
    // if (context.mounted) {
    SnackBarGlobal.show(
      message: e.message,
    );
    // }
    // handleCrash(details: FlutterErrorDetails(exception: e, stack: stackTrace));

    // throw DataException(message: e.message);
  } on GeneralException catch (e) {
    // Handle general exception
    printFullText(e.message);

    // handleCrash(details: FlutterErrorDetails(exception: e, stack: stackTrace));
    SnackBarGlobal.show(
      message: e.message,
    );
    // throw GeneralException(message: e.message);
  } catch (e) {
    // Handle any other exceptions

    if (onException != null) {
      onException();
    }
    rethrow;
  }
}

// Future<void> handleCrash({required FlutterErrorDetails details}) async {
//   await FirebaseCrashlytics.instance
//       .recordError(
//     details.exception,
//     details.stack,
//   )
//       .then((value) {
//     debugPrint('recordError Success');
//   });
// }
