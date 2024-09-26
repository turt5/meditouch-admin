import 'dart:convert';

import 'package:http/http.dart' as http;

class EmailSender {
  final String url = 'https://smtp-mail-three.vercel.app/send-email';

  Future<bool> send(String to, String subject, String text, String html) async {
    try {
      final response = await http.post(Uri.parse(url), headers: {
        "email": "meditouch.bcrypt@gmail.com",
        "security": "uvypgvlofsrocwxf",
      }, body: {
        'to': to,
        'subject': subject,
        'text': text,
        'html': html
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'successful') {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
