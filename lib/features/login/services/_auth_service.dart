import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../shared/local_db/_db_helper.dart';
import '../../../shared/local_db/person.dart';
import '../views/_loginpage.dart';
import '../views/_loginpage2.dart';

class LoginService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final DBHelper dbHelper = DBHelper();

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user == null) {
        return {'error': 'User not found'};
      }

      // Sign in complete, now get data from Firestore
      DocumentSnapshot userDoc =
          await db.collection('users').doc(user.uid).get();
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData == null) {
        return {'error': 'User data not found in Firestore'};
      }

      // create a person object
      Person person = Person(
        id: user.uid,
        name: userData['name'],
        email: userData['email'],
        phone: userData['phone'],
        gender: userData['gender'],
        dob: userData['dob'],
        imageUrl: userData['imageUrl'],
        role: userData['role'],
      );

      // Store data in local database
      await dbHelper.insertUser(person);

      return userData;
    } on FirebaseAuthException catch (e) {
      return {'error': e.message.toString()};
    } catch (e) {
      print('Login error: $e');
      return {'error': 'An unknown error occurred'};
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      await auth.signOut();
      await dbHelper.deleteUser(); // Delete user data from SQLite
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage2()),
      );
    } catch (e) {
      print('Logout error: $e');
      // Handle errors related to logout here
    }
  }
}
