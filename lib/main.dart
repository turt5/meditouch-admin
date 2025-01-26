import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meditouch_admin/core/theming/_theme.dart';
import 'package:meditouch_admin/features/dashboard_navigation/views/_admin_dashboard.dart';
import 'package:meditouch_admin/features/login/controller/login_controller.dart';
import 'package:meditouch_admin/features/login/views/_loginpage2.dart';
import 'package:meditouch_admin/firebase_options.dart';
import 'package:meditouch_admin/shared/local_db/_db_helper.dart';
import 'package:meditouch_admin/shared/local_db/person.dart';

import 'app/meditouch_admin.dart';
import 'features/add_doctor/controller/add_doctor_controller.dart';
import 'features/add_emergency_doctor/viewmodels/_add_emergency_doctor_vm.dart';
import 'features/dashboard_navigation/controller/navigation_controller.dart';

void main() async {
  // Ensure that the Flutter binding is initialized before calling the runApp() function.
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //initialize hive
  await Hive.initFlutter();

  //initialize local database
  DBHelper dbHelper = DBHelper();
  await dbHelper.initDb();

  final Person? person = dbHelper.getUser();

  // inject login controller
  Get.put(LoginController());

  // inject navigation controller
  Get.put(NavigationController());

  // inject add doctor controller
  Get.put(AddDoctorController());

  Get.put(AddEmergencyDoctorController()); 

  // Run the app
  runApp(ProviderScope(
    child: MeditouchAdmin(
      person: person,
    ),
  ));
}
