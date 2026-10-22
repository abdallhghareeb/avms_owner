import 'package:dio/dio.dart';

import 'dio_helper.dart';
import 'end_point.dart';

typedef DeleteAccountRequest = Future<Response<dynamic>> Function({
  required String url,
  required String token,
  required Map<String, dynamic> data,
});

/// Uses the same authenticated self-deletion contract as Visitor System.
class AccountDeletionService {
  AccountDeletionService({DeleteAccountRequest? request})
      : _request = request ?? DioHelper.postData;

  final DeleteAccountRequest _request;

  Future<void> deleteCurrentAccount({
    required String server,
    required String token,
    required String userId,
  }) async {
    final baseUrl = normalizeApiUrl(server);
    if (baseUrl.isEmpty || token.trim().isEmpty || userId.trim().isEmpty ||
        token == 'null' || userId == 'null') {
      throw StateError('Missing authenticated account or server');
    }
    // Send once. Never automatically retry a destructive request.
    final response = await _request(
      url: '$baseUrl/api/v1/user/delete',
      token: token,
      data: {'id': userId},
    );
    final payload = response.data;
    if (![200, 201, 204].contains(response.statusCode) ||
        payload == false ||
        (payload is Map && payload['succeeded'] == false)) {
      throw StateError('The server did not confirm account deletion');
    }
  }
}
