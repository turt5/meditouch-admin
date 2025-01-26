import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:math';
import 'dart:html' as html; // For handling file input in web
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../../../shared/services/_send_mail.dart';

class AgentAddService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Upload image specifically for web using `putData` with bytes
  /// Upload image based on the platform
  Future<String> uploadImage(dynamic image) async {
    try {
      if (kIsWeb && image is html.File) {
        // For web, we need to handle the blob URL
        final reader = html.FileReader();
        reader.readAsArrayBuffer(image);
        await reader.onLoadEnd.first;

        // Get the bytes from the reader
        final Uint8List imageBytes = reader.result as Uint8List;

        // Reference in Firebase storage
        final Reference ref = storage
            .ref()
            .child('agents/${DateTime.now().millisecondsSinceEpoch}');

        // Upload the image as raw bytes using `putData`
        final UploadTask uploadTask = ref.putData(imageBytes);
        final TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL for the uploaded image
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        print('Image uploaded! URL: $downloadUrl');
        return downloadUrl;
      } else if (!kIsWeb && image is File) {
        // For mobile, we can upload the file directly
        final Reference ref = storage
            .ref()
            .child('agents/${DateTime.now().millisecondsSinceEpoch}');

        // Upload the image using `putFile`
        final UploadTask uploadTask = ref.putFile(image);
        final TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL for the uploaded image
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        print('Image uploaded! URL: $downloadUrl');
        return downloadUrl;
      } else {
        throw UnsupportedError("Invalid image type or platform");
      }
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<bool> addAgent(Map<String, dynamic> data) async {
    try {
      String password = generatePassword();

      // Create a new user with email and password
      UserCredential _userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: data['email'],
        password: password,
      );

      User? _user = _userCredential.user;

      if (_user == null) {
        return false;
      }

      // await _firestore.collection('doctors');

      data['uid'] = _user.uid;

      await _firestore
          .collection('db_client_agent_userinfo')
          .doc(_user.uid)
          .set(data);

      // Send email to the doctor

      EmailSender emailSender = EmailSender();
      const String subject = 'Login Credentials for MediTouch Doctor Account';
      const String text = '';
      String html = """<!DOCTYPE html>
<html lang="en">
  <head>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
      rel="stylesheet"
    />
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login Information</title>
    <style>
      body {
        font-family: "Poppins", sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
        max-height: 100%;

      }
      .container {
        background-color: #ffffff;
        width: 100%;
        max-width: 600px;
        margin: 20px auto;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      }
      .header {
        background-color: #5c05ae;
        color: white;
        text-align: center;
        padding: 20px 0;
        border-radius: 8px 8px 0 0;
      }
      .content {
        padding: 20px;
        line-height: 1.6;
        color: #333;
      }
      .content h1 {
        font-size: 24px;
        margin-bottom: 20px;
      }
      .content p {
        font-size: 16px;
      }
      .credentials {
        background-color: #f8f8f8;
        border: 1px solid #ddd;
        padding: 10px;
        margin: 20px 0;
        border-radius: 4px;
      }
      .credentials p {
        margin: 0;
        font-weight: bold;
      }
      .footer {
        text-align: center;
        padding: 20px;
        font-size: 12px;
        color: #999;
      }

      .support-email {
        color: rgb(0, 110, 255);
        font-weight: bold;
      }

      .team {
        color: #5c05ae;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="header">
        <h2>MediTouch</h2>
      </div>
      <div class="content">
        <h1>Hi ${data['name']},</h1>
        <p>
          Welcome to MediTouch!<br />
          Here are your agent login credentials. This is an auto generated password,
          please change your password after login!
        </p>
        <div class="credentials">
          <p>Email: <span>${data['email']}</span></p>
          <p>Password: <span>$password</span></p>
        </div>
        <p>
          If you have any issues logging in, you can contact us -
          meditouch.bcrypt@gmail.com
        </p>
        <p>Best regards,<br /><span class="team">MediTouch</span></p>
      </div>
      <div class="footer">
        <p>&copy; 2024 MediTouch. All rights reserved.</p>
      </div>
    </div>
  </body>
</html>
""";
      bool emailResponse =
          await emailSender.send(data['email'], subject, text, html);

      if (!emailResponse) {
        return false;
      }
      return true;
    } catch (e) {
      print('Error adding doctor: $e');
      return false;
    }
  }

  String generatePassword() {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789#&!@?-_=+';
    final Random rnd = Random();
    final String password = String.fromCharCodes(Iterable.generate(
        8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    return password;
  }
}
