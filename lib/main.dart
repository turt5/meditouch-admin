import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meditouch_admin/core/theming/_theme.dart';
import 'package:meditouch_admin/features/dashboard_navigation/views/_admin_dashboard.dart';
import 'package:meditouch_admin/features/login/views/_loginpage2.dart';
import 'package:meditouch_admin/firebase_options.dart';
import 'package:meditouch_admin/shared/local_db/_db_helper.dart';
import 'package:meditouch_admin/shared/local_db/person.dart';

import 'features/login/views/_loginpage.dart';

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

  // Run the app
  runApp(ProviderScope(
      child: MyApp(
    person: person,
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.person});

  final Person? person;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme().getTheme(),
      home: person != null &&
              person!.id.isNotEmpty &&
              person!.role.isNotEmpty &&
              person!.role == 'a'
          ? AdminDashboard()
          : LoginPage2(),
    );
  }
}
