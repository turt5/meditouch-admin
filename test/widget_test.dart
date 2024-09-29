import 'dart:convert';
import 'package:meditouch_admin/shared/services/_email_verifier_test.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('EmailVerifierService Tests', () {
    test('verify method should return true for valid email', () async {
      print('Running test: verify method for valid email');

      // Mock client response for a valid email
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'status': 'valid'}), 200);
      });

      final service = EmailVerifierService(client: mockClient);

      final result = await service.verify('test@example.com');
      print('Result for valid email: $result');
      expect(result, isTrue);
    });

    test('verify method should return false for invalid email', () async {
      print('Running test: verify method for invalid email');

      // Mock client response for an invalid email
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'status': 'invalid'}), 200);
      });

      final service = EmailVerifierService(client: mockClient);

      final result = await service.verify('eta-ekta-invalid-email@gmail.com');
      print('Result for invalid email: $result');
      expect(result, isFalse);
    });

    test('verify method should return false for non-200 status codes', () async {
      print('Running test: verify method for non-200 status codes');

      // Mock client response with a non-200 status code
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = EmailVerifierService(client: mockClient);

      final result = await service.verify('eta-ekta-invalid-email@gmail.com');
      print('Result for non-200 status code: $result');
      expect(result, isFalse);
    });

    test('verifyAndGetData method should return data for valid response', () async {
      print('Running test: verifyAndGetData method for valid response');

      // Mock client response with valid data
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({
          'status': 'valid',
          'email': 'kalimon291@gmail.com',
          'domain': 'gmail.com',
        }), 200);
      });

      final service = EmailVerifierService(client: mockClient);

      final data = await service.verifyAndGetData('kalimon291@gmail.com');
      print('Data received for valid response: $data');
      expect(data['status'], equals('valid'));
      expect(data['email'], equals('kalimon291@gmail.com'));
    });

    test('verifyAndGetData method should return empty map for non-200 status codes', () async {
      print('Running test: verifyAndGetData method for non-200 status codes');

      // Mock client response with a non-200 status code
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = EmailVerifierService(client: mockClient);

      final data = await service.verifyAndGetData('kalimon291@gmail.com');
      print('Data received for non-200 status code: $data');
      expect(data, isEmpty);
    });

    test('verifyAndGetData method should handle exceptions and return empty map', () async {
      print('Running test: verifyAndGetData method for exceptions');

      // Mock client to throw an exception
      final mockClient = MockClient((request) async {
        throw Exception('Network Error');
      });

      final service = EmailVerifierService(client: mockClient);

      final data = await service.verifyAndGetData('kalimon291@gmail.com');
      print('Data received for exception: $data');
      expect(data, isEmpty);
    });
  });
}
