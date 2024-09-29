import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailVerifierService {
  late http.Client client;

  // Constructor with dependency injection
  EmailVerifierService({required this.client});

  Future<bool> verify(String email) async {
    String apiKey = "516ab40faaec419288e3d2390d74ccf4";
    String apiUrl = 'https://api.zerobounce.net/v2/validate?api_key=' +
        apiKey +
        '&email=' +
        email;

    try {
      final response = await client.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'valid') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> verifyAndGetData(String email) async {
    String apiKey = "516ab40faaec419288e3d2390d74ccf4";
    String apiUrl = 'https://api.zerobounce.net/v2/validate?api_key=' +
        apiKey +
        '&email=' +
        email;

    try {
      final response = await client.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }
}
