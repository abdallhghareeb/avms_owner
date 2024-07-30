

import 'package:avms/services/api_service/end_point.dart';
import 'package:avms/services/local/cache_helper.dart';
import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      "Content-Type": "application/json",
    });
    // get token from the storage
    if (CacheHelper.userToken != null) {
      options.headers.addAll({
        "Authorization": "Bearer ${CacheHelper.userToken}",
      });
    }
    return super.onRequest(options, handler);
  }



}