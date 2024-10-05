import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:math';
import 'dart:html' as html; // For handling file input in web
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class NurseAddService{


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
            .child('nurses/${DateTime.now().millisecondsSinceEpoch}');

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
            .child('doctors/${DateTime.now().millisecondsSinceEpoch}');

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

  Future<void> addNurse(Map<String, dynamic> nurseData) async {
    try {
      await _firestore.collection('nurses').add(nurseData);
    } catch (e) {
      print(e);
    }
  }
}