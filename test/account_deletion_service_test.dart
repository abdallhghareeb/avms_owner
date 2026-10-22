import 'package:avms/services/api_service/account_deletion_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deletes the authenticated user using the Visitor System API contract', () async {
    var calls = 0;
    final service = AccountDeletionService(request: ({required url, required token, required data}) async {
      calls++;
      expect(url, 'https://facility.example/api/v1/user/delete');
      expect(token, 'test-token');
      expect(data, {'id': 'current-user'});
      return Response(requestOptions: RequestOptions(path: url),
          statusCode: 200, data: {'succeeded': true});
    });
    await service.deleteCurrentAccount(server: 'https://facility.example/api/v1',
        token: 'test-token', userId: 'current-user');
    expect(calls, 1);
  });

  test('missing session or invalid server never sends a deletion request', () async {
    final service = AccountDeletionService(request: ({required url, required token, required data}) async {
      fail('No request should be sent');
    });
    for (final values in [
      ['', 'test-token', 'user'], ['https://facility.example', '', 'user'],
      ['https://facility.example', 'test-token', ''],
      ['https://facility.example', 'null', 'user'],
    ]) {
      await expectLater(service.deleteCurrentAccount(server: values[0], token: values[1], userId: values[2]),
          throwsStateError);
    }
  });

  test('HTTP failure and business rejection never report success or retry', () async {
    for (final scenario in [
      [401, {'message': 'Unauthorized'}], [403, null], [500, null],
      [200, {'succeeded': false}], [200, false],
    ]) {
      var calls = 0;
      final service = AccountDeletionService(request: ({required url, required token, required data}) async {
        calls++;
        return Response(requestOptions: RequestOptions(path: url),
            statusCode: scenario[0] as int, data: scenario[1]);
      });
      await expectLater(service.deleteCurrentAccount(server: 'https://facility.example',
          token: 'test-token', userId: 'current-user'), throwsStateError);
      expect(calls, 1);
    }
  });

  test('network uncertainty propagates without retrying', () async {
    var calls = 0;
    final service = AccountDeletionService(request: ({required url, required token, required data}) async {
      calls++;
      throw DioException(requestOptions: RequestOptions(path: url),
          type: DioExceptionType.receiveTimeout);
    });
    await expectLater(service.deleteCurrentAccount(server: 'https://facility.example',
        token: 'test-token', userId: 'current-user'), throwsA(isA<DioException>()));
    expect(calls, 1);
  });
}
