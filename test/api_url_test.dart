import 'package:avms/services/api_service/end_point.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HTTPS stays encrypted and API suffix is not duplicated', () {
    expect(normalizeApiUrl(' https://server.example.com:8644/api/v1/ '),
        'https://server.example.com:8644');
    expect(normalizeApiUrl('HTTPS://server.example.com/'),
        'https://server.example.com');
  });

  test('legacy server settings remain compatible', () {
    expect(normalizeApiUrl('egytest.ddns.net:8644'),
        'http://egytest.ddns.net:8644');
    expect(normalizeApiUrl('http://egytest.ddns.net:8644/api/v1'),
        'http://egytest.ddns.net:8644');
  });

  test('rejects credentials, unsupported schemes and non-server paths', () {
    for (final input in [
      '',
      '   ',
      'ftp://server.example.com',
      'https://user:secret@server.example.com',
      'https://server.example.com/other',
      'https://server.example.com?token=secret',
      'https://server.example.com/#bad',
      'https://bad host.example.com'
    ]) {
      expect(normalizeApiUrl(input), '', reason: input);
    }
  });
}
