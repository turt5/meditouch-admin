import 'dart:typed_data';
import 'dart:html' as html; // For handling file input in web
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb check

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  /// Upload image specifically for web using `putData` with bytes
  Future<String> uploadImage(XFile image) async {
    try {
      if (kIsWeb) {
        // For web, we need to handle the blob URL
        final Uint8List? imageBytes = await image.readAsBytes(); // Read image bytes
        if (imageBytes == null) {
          print('Error: No image selected.');
          return '';
        }

        // Reference in Firebase storage
        final Reference ref = storage.ref().child('doctors/${DateTime.now().millisecondsSinceEpoch}');

        // Upload the image as raw bytes using `putData`
        final UploadTask uploadTask = ref.putData(imageBytes);
        final TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL for the uploaded image
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        print('Image uploaded! URL: $downloadUrl');
        return downloadUrl;
      } else {
        throw UnsupportedError("This method is for web only");
      }
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  /// Add doctor data to Firestore
  Future<bool> addDoctor(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('doctors').add(data);
      return true;
    } catch (e) {
      print('Error adding doctor: $e');
      return false;
    }
  }
}
