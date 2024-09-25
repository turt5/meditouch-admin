import 'dart:convert';

import 'package:http/http.dart' as http;

class EmailVerifier {
  Future<bool> verify(String email) async {
    String apiKey = "516ab40faaec419288e3d2390d74ccf4";
    String apiUrl = 'https://api.zerobounce.net/v2/validate?api_key=' +
        apiKey +
        '&email=' +
        email;

    try {
      final response = await http.get(Uri.parse(apiUrl));

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
}
